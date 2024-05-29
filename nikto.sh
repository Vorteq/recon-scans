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
echo "[]" > nikto_results.json

for item in $@
do
  echo $item
  mkdir -p $item/nikto/non-ssl $item/nikto/ssl
  cd $item/nikto/non-ssl
  pwd
  nikto -h $item -o $item.txt &
  cd ../ssl
  pwd
  nikto -ssl -h $item -o $item.txt &
  # Wait for all background processes to finish
  wait

  cd ../../../

  # Parse the output of each program and convert it to JSON
  nikto_json=$(cat $item/nikto/non-ssl/$item.txt $item/nikto/ssl/$item.txt | sed 's/\\//g' | jq -R -s -c 'split("\n")')

  # Append the JSON object to the array in the file
  jq ". += [{\"target\": \"$item\", \"results\": [{\"program\": \"nikto\", \"output\": $nikto_json}]}]" nikto_results.json > tmp.json && mv tmp.json nikto_results.json
done