#!/bin/bash

myip=$(curl -s ifconfig.me)						# Retrieve the external IP address of the server
mydomain="YOUR_DOMAIN_HERE"				               	# Namecheap domain to update
myhost="YOUR_HOSTS_HERE"				               	# Domain hosts to update, separated by commas
password="YOUR_PASSWORD_HERE"						# Security key for the DNS update API (replace with your actual key)
logfile="YOUR_LOGFILE_PATH_HERE"					# Define the log file path
enable_logging=YOUR_LOGGING_PREFERENCE_HERE				# Enable or disable logging (set to 1 to enable, 0 to disable)




#### DO NOT MODIFY AFTER THIS LINE ####



# Function to log messages
log_message() {
    if [[ $enable_logging -eq 1 ]]; then
        echo "$@" | tee -a $logfile
    else
        echo "$@"
    fi
}

# Loop through each host to update
for i in ${myhost//,/ }; do
    log_message "Processing host: $i"
    
    # Call Namecheap's API to update the host's IP address and store response
    response=$(curl -k -s "https://dynamicdns.park-your-domain.com/update?host=$i&domain=$mydomain&password=$password&ip=$myip")
    
    # Check for error count in the response
    errCount=$(echo $response | grep -oP '<ErrCount>\K[0-9]+')
    
    if [[ $errCount -gt 0 ]]; then
        log_message "Error encountered while updating $i. Error count: $errCount"
        # Handle error appropriately (log it, retry, send notification, etc.)
    else
        log_message "Update successful for $i."
    fi
    
    log_message "-------------- $(date '+%Y-%m-%d %H:%M:%S') --------------"
    log_message "" # This adds an empty line after the separator for better readability
    # Pause for 5 seconds to avoid overwhelming the server
    sleep 5
done
