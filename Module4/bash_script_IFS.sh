#!/bin/bash

keys=("frame.time" "wlan.fc.type" "wlan.fc.subtype")
> output.txt
while IFS= read -r line
do
  for k in "${keys[@]}"; do
    if [[ "$line" == *"\"$k\""* ]]; then
	echo "$line" >> output.txt
	break
    fi
  done
done <"$1"
