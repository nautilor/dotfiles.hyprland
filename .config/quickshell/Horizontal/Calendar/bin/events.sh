#!/usr/bin/env bash
set -euo pipefail

# Accetta la data come parametro, altrimenti usa oggi
MONTH_START="${1:-$(date +%Y-%m-01)}"
MONTH_END=$(date -d "$MONTH_START +1 month" +%Y-%m-%d)

gcalcli agenda --details calendar "$MONTH_START" "$MONTH_END" --tsv | jq -R -s '
  def calendar_colors:
    {
			"Edoardo": "#89b4fa",
      "Personale": "#f38ba8",
      "Edo & Albe": "#a6e3a1",
			"Info Edo & Albe": "#a6e3a1",
      "Altro": "#f9e2af"
    };

  split("\n")
  | map(select(length > 0))
  | map(split("\t"))
  | map({
      start_date: .[0],
      start_time: .[1],
      end_time: .[3],
      title: .[4],
      calendar: .[5],
      color: (calendar_colors[.[5]] // "#cdd6f4")
    })
'

