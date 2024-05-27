#!/bin/bash

#List with the targets
echo -e "echo: \n$@"

#Set the field separator to new line
IFS=","
# Get the directory of the script
script_dir=$(dirname $0)
# Create the results directory inside the script directory
if [ ! -d "$script_dir/results" ]; then
  mkdir "$script_dir/results"
  echo "Scan folder made"
fi
#Scans the target
echo "For loop over command output:"

# Get the current timestamp
timestamp=$(date +"%d-%m-%Y_%H:%M:%S")

# Create a new directory for this scan
mkdir -p "$script_dir/results/$timestamp"
cd "$script_dir/results/$timestamp"

# Initialize an empty JSON array
echo "[]" > scan_results.json

for item in $@
do
  echo $item
  mkdir -p $item
  ping $item -c 2 >> $item/$item-ICMP.txt &
  sslscan $item >> $item/$item-sslscan.txt &
  nikto -h $item >> $item/$item-nikto.txt &
  curl -kv $item | tr -d '\r' >> $item/$item-headers.txt &
  nmap -sV -A $item >> $item/$item-nmap.txt &

  # Wait for all background processes to finish
  wait

  # Parse the output of each program and convert it to JSON
  ping_json=$(cat $item/$item-ICMP.txt | sed 's/\\//g' | jq -R -s -c 'split("\n")')
  sslscan_output=$(cat $item/$item-sslscan.txt | sed 's/\x1b\[[0-9;]*m//g')
  sslscan_json=$(echo "$sslscan_output" | jq -R -s -c 'split("\n")')
  nikto_json=$(cat $item/$item-nikto.txt | sed 's/\\//g' | jq -R -s -c 'split("\n")')
  curl_json=$(cat $item/$item-headers.txt | sed 's/\\//g' | jq -R -s -c 'split("\n")')
  nmap_json=$(cat $item/$item-nmap.txt | sed 's/\\//g' | jq -R -s -c 'split("\n")')

  # Append the JSON object to the array in the file
  jq ". += [{\"target\": \"$item\", \"results\": [{\"program\": \"ping\", \"output\": $ping_json}, {\"program\": \"sslscan\", \"output\": $sslscan_json}, {\"program\": \"nikto\", \"output\": $nikto_json}, {\"program\": \"curl\", \"output\": $curl_json}, {\"program\": \"nmap\", \"output\": $nmap_json}]}]" scan_results.json > tmp.json && mv tmp.json scan_results.json
done