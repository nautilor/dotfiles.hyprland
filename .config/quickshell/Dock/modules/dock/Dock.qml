
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
Scope {
	id : dockScope
    PanelWindow {
        id: dock
				property bool dockHidden: true
			  exclusionMode: ExclusionMode.Normal
        anchors {
            bottom: true
				}

				margins {
					bottom: dockHidden ? -height + 10 : 0
				}

				implicitHeight: 86
				implicitWidth: dockLayout.width + 40

				Behavior on implicitHeight {
						NumberAnimation {
								duration: 250
								easing.type: Easing.OutCubic
						}
				}
        
        color: "#00000000"
        
        Item {
            anchors.fill: parent 
            Rectangle {
                id: dockBackground
                anchors.horizontalCenter: parent.horizontalCenter
								anchors.bottom: parent.bottom
                
                // Autohide animation
                anchors.bottomMargin: 8
                
                Behavior on anchors.bottomMargin {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }
                
                width: dockLayout.width + 20
                height: 70
                
                color: "#201e1e2e"
                radius: 16
                border.color: "#4089b4fa"
                border.width: 1
                opacity: 0.95
                
                
                // Show trigger area - thin strip at bottom of screen
                MouseArea {
                    id: showTrigger
                    anchors.fill: parent
                    anchors.topMargin: parent.height - 5
                    hoverEnabled: true
                    propagateComposedEvents: true
                    
                    onEntered: {
                        hideTimer.stop()
                        dock.dockHidden = false
                    }
                    
                    onExited: {
                        if (!dockArea.containsMouse) {
                            hideTimer.restart()
                        }
                    }
                    
                    onPressed: function(mouse) {
                        mouse.accepted = false
                    }
                }
                
                // Main dock area
                MouseArea {
                    id: dockArea
                    anchors.fill: parent
                    hoverEnabled: true
                    propagateComposedEvents: true
                    
                    onEntered: {
                        hideTimer.stop()
                        dock.dockHidden = false
                    }
                    
                    onExited: {
                        if (!showTrigger.containsMouse) {
                            hideTimer.restart()
                        }
                    }
                    
                    // Let clicks pass through to icon MouseAreas
                    onPressed: function(mouse) {
                        mouse.accepted = false
                    }
                }
                
                // Timer to auto-hide after mouse leaves
                Timer {
                    id: hideTimer
                    interval: 800
                    running: false
                    repeat: false
                    onTriggered: {
                        if (!dockArea.containsMouse && !showTrigger.containsMouse) {
                            dock.dockHidden = true
                        }
                    }
                }
                
                // Start hidden after a short delay
                Component.onCompleted: {
                    startTimer.start()
                }
                
                Timer {
                    id: startTimer
                    interval: 2000
                    running: false
                    repeat: false
                    onTriggered: {
                        dock.dockHidden = true
                    }
                }
               RowLayout {
                    id: dockLayout
                    anchors.centerIn: parent
                    spacing: 8
                    
                    // App icons - customize these to your apps
                    DockIcon {
                        iconName: "zen-browser"
                        command: "zen-browser"
                    }
                    
                    DockIcon {
                        iconName: "idea"
                        command: "idea"
                    }
                    
                    DockIcon {
                        iconName: "kitty"
                        command: "kitty"
                    }
                    
                    DockIcon {
                        iconName: "nemo"
                        command: "nemo"
                    }
										DockIcon {
												iconName: "thunderbird"
												command: "thunderbird"
										}
										DockIcon {
												iconName: "spotify"
												command: "hyprctl dispatch togglespecialworkspace"
										}
                    
                    // Separator
                    Rectangle {
                        Layout.preferredWidth: 2
                        Layout.preferredHeight: 48
                        Layout.leftMargin: 4
                        Layout.rightMargin: 4
                        color: "#4089b4fa"
                        radius: 1
                    }
                    
                    DockIcon {
                        iconName: "system-file-manager"
                        command: "nemo ~"
                    }
                    
                    DockIcon {
                        iconName: "trash-full"
                        command: "nemo trash://"
                    }
                
                }
            }
        }
    }
    
    // Reusable dock icon component
    component DockIcon: Rectangle {
        id: iconItem
        property string iconName: ""
        property string command: ""
        
        Layout.preferredWidth: 48
        Layout.preferredHeight: 48
        color: "transparent"
        radius: 8
        
        scale: mouseArea.containsMouse ? 1.2 : 1.0
        
        Behavior on scale {
            NumberAnimation { 
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        
        Process {
            id: proc
            running: false
        }
        
        // Icon background on hover
        Rectangle {
            anchors.fill: parent
            color: "#30cba6f7"
            radius: 8
            opacity: mouseArea.containsMouse ? 1 : 0
            
            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }
        }
        
        Image {
            anchors.centerIn: parent
            width: 40
            height: 40
            source: "image://icon/" + iconName
            sourceSize: Qt.size(40, 40)
            smooth: true
            
            // Fallback if icon not found
            onStatusChanged: {
                if (status === Image.Error) {
                    source = "image://icon/application-x-executable"
                }
            }
        }
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            
            onClicked: {
                if (iconItem.command) {
                    proc.command = ["/bin/sh", "-c", iconItem.command];
                    proc.running = true;
                }
            }
        }
        
        // Running indicator dot
        Rectangle {
            width: 4
            height: 4
            radius: 2
            color: "#89b4fa"
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: -4
            }
            visible: false
        }
    }
}
