# Full Scan Script

The `fullscan.sh` script is a bash script designed to perform a series of scans on a list of domains. The script performs the following operations:

1. **Check and Install Required Programs**: The script first checks if the required programs (`ping`, `sslscan`, `nikto`, `curl`, `nmap`) are installed on the system. If any of these programs are not installed, the script automatically installs them using `sudo apt install -y`.

2. **Prepare for Scanning**: The script accepts a list of domains as command-line arguments, separated by commas. It then creates a directory named `scans_full_scan` in the same directory as the script, if it doesn't already exist.

3. **Perform Scans**: For each domain in the list, the script performs the following scans in parallel:
    - ICMP echo request using `ping`
    - SSL scan using `sslscan`
    - Web server scan using `nikto`
    - HTTP headers retrieval using `curl`
    - Network scan using `nmap`

   The results of each scan are saved in separate text files in a directory named after the domain under the `scans_full_scan` directory.

4. **Wait for Completion**: After initiating all the scans, the script waits for all of them to complete before it finishes execution.

Please note that running commands in parallel can consume more system resources and may slow down your system if you have many domains in your list.