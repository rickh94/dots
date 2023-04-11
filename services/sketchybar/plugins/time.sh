#!/usr/bin/env bash

mins=$(date '+%M')
hours=$(date '+%H')
fuzzymins=$(awk '{for (i=1; i<NF; i++) $i = int( ($i+2) / 5) * 5} 1' <<< "$mins")

# handle special cases
if [ $fuzzymins -gt 55 ]; then
  fuzzymins="00"
  hours=$(date -v+1H "+%H")
elif [ ${#fuzzymins} -eq 1 ]; then
  fuzzymins="0$fuzzymins"
fi

sketchybar --set $NAME label="$hours:$fuzzymins"
