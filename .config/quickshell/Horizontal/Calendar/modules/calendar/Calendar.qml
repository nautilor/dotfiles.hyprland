import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Scope {
	// Funzioni helper globali
	QtObject {
		id: calendarUtils

		function getMonthName(month) {
			const months = ["January", "February", "March", "April", "May", "June",
			"July", "August", "September", "October", "November", "December"]
			return months[month]
		}

		function getDaysInMonth(year, month) {
			return new Date(year, month + 1, 0).getDate()
		}

		function getFirstDayOfMonth(year, month) {
			let day = new Date(year, month, 1).getDay()
			return day === 0 ? 6 : day - 1 // Monday = 0
		}

		function isSameDay(date1, date2) {
			return date1.getFullYear() === date2.getFullYear() &&
			date1.getMonth() === date2.getMonth() &&
			date1.getDate() === date2.getDate()
		}

		function getEventsForDate(date, events) {
			const dateStr = Qt.formatDate(date, "yyyy-MM-dd")
			const filtered = events.filter(event => {
				if (!event.start_time) return false
				const eventDate = event.start_date.split(" ")[0]
				return eventDate === dateStr
			})
			return filtered
		}
	}

	PanelWindow {
		id: root
		visible: true
		implicitWidth: 600
		implicitHeight: 350
		focusable: true
		margins {
			top: 5
			left: 0
		}
		color: "transparent"
		anchors {
			top: true
			left: false
		}
		exclusionMode: ExclusionMode.Normal

		property var currentDate: new Date()
		property var events: []
		property var selectedDate: new Date()
		property bool eventsLoaded: false

		Component.onCompleted: {
			root.loadEvents()
		}

		Process {
			id: calendarClose
			command: [
				"/bin/bash",
				Quickshell.env("HOME") + "/.config/quickshell/Horizontal/Calendar/bin/calendar.sh",
			]
		}

		// Load events process
		Process {
			id: eventsProc

			property string scriptPath: {
				const home = Quickshell.env("HOME")
				return home + "/.config/quickshell/Horizontal/Calendar/bin/events.sh"
			}

			property string accumulatedOutput: ""

			command: [
				"/bin/bash", 
				scriptPath,
				Qt.formatDate(root.currentDate, "yyyy-MM-01")
			]

			running: false

			stdout: SplitParser {
				onRead: data => {
					eventsProc.accumulatedOutput += data
				}
			}

			stderr: SplitParser {
				onRead: data => console.error("Errore gcalcli:", data)
			}

			onRunningChanged: {
				if (!running && accumulatedOutput.length > 0) {
					try {
						const parsed = JSON.parse(accumulatedOutput)
						root.events = parsed
						root.eventsLoaded = true
					} catch(e) {
						console.error("Error parsing JSON:", e)
						root.events = []
					}
					accumulatedOutput = ""
				}
			}
		}

		function loadEvents() {
			root.selectedDate = new Date(root.currentDate.getFullYear(), root.currentDate.getMonth(), selectedDate.getDate())
			eventsProc.running = true
		}
		Item {
			anchors.fill: parent
			Shortcut {
				sequence: "Escape"
				onActivated: {
					// Run the script located at ~/.config/quickshell/Calendar/bin/calendar.sh
					calendarClose.running = true
				}
			}

			Rectangle {
				anchors.fill: parent
				color: "#801e1e2e"
				border.color: "#313244"
				border.width: 1
				radius: 16
				ColumnLayout {
					anchors.fill: parent
					anchors.margins: 16
					spacing: 12

					// Header with month navigation
					RowLayout {
						Layout.fillWidth: true
						spacing: 12
						Text {
							Layout.fillWidth: true
							text: calendarUtils.getMonthName(root.currentDate.getMonth()) + " " + root.currentDate.getFullYear()
							color: "#cdd6f4"
							font.pixelSize: 24
							font.bold: true
							horizontalAlignment: Text.AlignHStart
						}

						RowLayout {
							spacing: 8
							Rectangle {
								Layout.preferredWidth: 40
								Layout.preferredHeight: 40
								color: prevMouseArea.containsMouse ? "#313244" : "transparent"
								radius: 30
								Text {
									anchors.centerIn: parent
									text: ""
									color: "#cdd6f4"
									font.pixelSize: 14
								}

								MouseArea {
									id: prevMouseArea
									anchors.fill: parent
									hoverEnabled: true
									onClicked: {
										let newDate = new Date(root.currentDate)
										newDate.setMonth(newDate.getMonth() - 1)
										root.currentDate = newDate
										root.loadEvents()
									}
								}
							}


							Rectangle {
								Layout.preferredWidth: 40
								Layout.preferredHeight: 40
								color: nextMouseArea.containsMouse ? "#313244" : "transparent"
								radius: 30

								Text {
									anchors.centerIn: parent
									text: ""
									color: "#cdd6f4"
									font.pixelSize: 14
								}

								MouseArea {
									id: nextMouseArea
									anchors.fill: parent
									hoverEnabled: true
									onClicked: {
										let newDate = new Date(root.currentDate)
										newDate.setMonth(newDate.getMonth() + 1)
										root.currentDate = newDate
										root.loadEvents()
									}
								}
							}

							Rectangle {
								Layout.preferredWidth: 40 * 2
								Layout.preferredHeight: 40
								color: todayMouseArea.containsMouse ? "#313244" : "transparent"
								radius: 30
								border.color: "#89b4fa"
								border.width: 1

								Text {
									anchors.centerIn: parent
									text: "Today"
									color: "#89b4fa"
									font.pixelSize: 14
									horizontalAlignment: Text.AlignHStart
								}

								MouseArea {
									id: todayMouseArea
									anchors.fill: parent
									hoverEnabled: true
									onClicked: {
										root.currentDate = new Date()
										root.selectedDate = new Date()
										root.loadEvents()
									}
								}
							}
						}
					}


					// Days and events panel
					RowLayout {
						Layout.fillWidth: true
						Layout.fillHeight: true
						spacing: 12
						ColumnLayout {
							GridLayout {
								Layout.fillWidth: true
								Layout.fillHeight: true
								columns: 7
								columnSpacing: 10
								rowSpacing: 10

								Repeater {
									model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
									Text {
										Layout.preferredWidth: (root.implicitWidth) / 16
										Layout.preferredHeight: 30
										text: modelData
										color: "#7f849c"
										font.pixelSize: 12
										font.bold: true
										horizontalAlignment: Text.AlignHCenter
										verticalAlignment: Text.AlignVCenter
									}
								}
							}

							GridLayout {
								Layout.fillWidth: true
								Layout.fillHeight: true
								columns: 7
								columnSpacing: 10
								rowSpacing: 10 
								Repeater {
									model: 42 // 6 weeks    
									Rectangle {
										Layout.preferredWidth: (root.implicitWidth) / 16
										Layout.preferredHeight: (root.implicitWidth) / 16

										property int dayOffset: index - calendarUtils.getFirstDayOfMonth(root.currentDate.getFullYear(), root.currentDate.getMonth())
										property var dayDate: new Date(root.currentDate.getFullYear(), root.currentDate.getMonth(), dayOffset + 1)
										property bool isCurrentMonth: dayOffset >= 0 && dayOffset < calendarUtils.getDaysInMonth(root.currentDate.getFullYear(), root.currentDate.getMonth())
										property bool isSelected: calendarUtils.isSameDay(dayDate, root.selectedDate)
										property bool isToday: calendarUtils.isSameDay(dayDate, new Date())
										property var dayEvents: isCurrentMonth ? calendarUtils.getEventsForDate(dayDate, root.events) : []
										property bool hasEvents: dayEvents.length > 0

										color: isSelected ? "#45475a" : (dayMouseArea.containsMouse ? "#313244" : "transparent")
										border.color: isToday ? "#89b4fa" : (hasEvents ? "transparent" : "#45475a")
										border.width: isToday ? 2 : (hasEvents ? 1 : 0)
										radius: 50

										ColumnLayout {
											anchors.fill: parent

											Text {
												Layout.alignment: Qt.AlignHCenter
												text: isCurrentMonth ? (dayOffset + 1) : ""
												color: isCurrentMonth ? "#cdd6f4" : "#585b70"
												font.pixelSize: 14
												font.bold: isToday
											} 
										}

										MouseArea {
											id: dayMouseArea
											anchors.fill: parent
											hoverEnabled: true
											enabled: isCurrentMonth
											onClicked: {
												root.selectedDate = dayDate
											}
										}
									}
								}
							}
						}

						// Events panel
						Rectangle {
							Layout.fillWidth: true
							Layout.preferredHeight: parent.height - 50
							anchors.top: parent.top 
							color: "transparent"
							radius: 8

							ColumnLayout {
								anchors.fill: parent
								anchors.margins: 6
								spacing: 8

								Flickable {
									Layout.fillWidth: true
									Layout.fillHeight: true
									contentHeight: eventsColumn.height
									clip: true

									ColumnLayout {
										id: eventsColumn
										width: parent.width
										spacing: 2           
										Repeater {
											model: calendarUtils.getEventsForDate(root.selectedDate, root.events)

											Rectangle {
												Layout.fillWidth: true
												Layout.preferredHeight: 40
												color: "transparent"
												radius: 6

												RowLayout {
													anchors.fill: parent
													spacing: 8
													Rectangle {
														Layout.preferredWidth: 3
														Layout.preferredHeight: parent.height - 10
														color: modelData.color || "#89b4fa"
														radius: 5
													}



													ColumnLayout {
														Layout.fillWidth: true
														spacing: 0
														RowLayout {
															spacing: 0
															Text {
																id: eventTitle
																text: modelData.title || "Senza titolo"
																color: "#cdd6f4"
																font.pixelSize: 12
																font.bold: true
																elide: Text.ElideRight
																Layout.fillWidth: true
															}
														}
														RowLayout {
															spacing: 0
															Text {
																text: {
																	if (!modelData.start_time || !modelData.end_time) return ""
																	return modelData.start_time + " - " + modelData.end_time
																}
																color: "#89b4fa"
																font.pixelSize: 10
															}
														}
													}
												}
											}
										}

										Text {
											Layout.fillWidth: true
											visible: calendarUtils.getEventsForDate(root.selectedDate, root.events).length === 0
											text: "No events for this date."
											color: "#7f849c"
											font.pixelSize: 11
											horizontalAlignment: Text.AlignHCenter
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
