#!/bin/bash

# Initialize an associative array to store IP counts
declare -A ip_count

# Initialize variables to count total unique IP addresses and total IP addresses
total_unique_ips=0
total_ips=0

# Log data (for demonstration, replace with your log file)
log_data='
192.168.1.1 - - [12/May/2024:10:14:32 +0000] "GET /index.html HTTP/1.1" 200 234
192.168.1.2 - - [12/May/2024:10:15:12 +0000] "POST /form HTTP/1.1" 404 112
192.168.1.3 - - [12/May/2024:10:15:45 +0000] "GET /about.html HTTP/1.1" 200 456
192.168.1.1 - - [12/May/2024:10:16:22 +0000] "GET /index.html HTTP/1.1" 200 234
192.168.1.4 - - [12/May/2024:10:17:01 +0000] "GET /contact.html HTTP/1.1" 200 678
192.168.1.2 - - [12/May/2024:10:17:40 +0000] "GET /index.html HTTP/1.1" 200 234
192.168.1.5 - - [12/May/2024:10:18:21 +0000] "GET /services.html HTTP/1.1" 500 789
'

# Read log data line by line
while read -r line; do
    # Extract the IP address (first field)
    ip=$(echo "$line" | awk '{print $1}')
    
    # Check if the IP address is not empty
    if [[ -n "$ip" ]]; then
        # Increment the count for this IP address
        ((ip_count["$ip"]++))
        
        # Increment the total IP count
        ((total_ips++))
    fi
done <<< "$log_data"

# Calculate total unique IP addresses
total_unique_ips=${#ip_count[@]}

# Display the unique IP addresses and their counts
echo "Unique IP addresses and their counts:"
for ip in "${!ip_count[@]}"; do
    echo "$ip: ${ip_count[$ip]}"
done

# Display the total count of unique IP addresses
echo "Total unique IP addresses: $total_unique_ips"

# Display the total count of IP addresses
echo "Total IP addresses: $total_ips"
