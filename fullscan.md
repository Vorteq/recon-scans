# Fullscan.sh Tutorial

## Introduction

`fullscan.sh` is a bash script designed to perform a comprehensive scan on a list of targets. It uses a variety of tools including `ping`, `sslscan`, `nikto`, `curl`, and `nmap` to gather information about each target. The results are then stored in a JSON file for easy parsing and analysis.

## Usage

To use `fullscan.sh`, simply pass the targets as arguments when running the script. For example:

```bash
./fullscan.sh "target1.com,target2.com,target3.com"
```

## Detailed Explanation

Here's a step-by-step breakdown of what happens when you run `fullscan.sh`:

1. **Setting up the environment**: The script first sets the field separator to a new line and gets the directory of the script. It then checks if a `results` directory exists within the script directory. If not, it creates one.

2. **Preparing for the scan**: The script generates a timestamp which is used to create a unique directory for the current scan within the `results` directory. It then initializes an empty JSON array in a file named `scan_results.json`.

3. **Performing the scan**: For each target passed as an argument, the script does the following:
   - Creates a directory for the target.
   - Runs `ping`, `sslscan`, `nikto`, `curl`, and `nmap` on the target. The output of each command is redirected to a separate text file.
   - Waits for all background processes to finish.
   - Parses the output of each program, removes any escape characters, and converts it to a JSON array.
   - Appends a JSON object containing the target and the results of each program to the array in `scan_results.json`.

## Output

The output of `fullscan.sh` is a JSON file named `scan_results.json` located in a timestamped directory within the `results` directory. Each entry in the JSON array represents a target and contains the results of each program run on that target.

For example, here's what an entry might look like:

```json
{
  "target": "target1.com",
  "results": [
    {
      "program": "ping",
      "output": [...]
    },
    {
      "program": "sslscan",
      "output": [...]
    },
    {
      "program": "nikto",
      "output": [...]
    },
    {
      "program": "curl",
      "output": [...]
    },
    {
      "program": "nmap",
      "output": [...]
    }
  ]
}
```

Each `output` array contains the lines of output produced by the corresponding program.

## Conclusion

`fullscan.sh` is a powerful tool for performing comprehensive scans on multiple targets. By storing the results in a JSON file, it allows for easy parsing and analysis of the data.