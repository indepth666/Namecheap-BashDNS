#!/bin/bash

# Retrieve the external IP address of the server
myip=$(curl -s ifconfig.me)

# Declare associative arrays for domains and their hosts, and for their passwords
declare -A domains
declare -A passwords

# Populate the domains array with your domain names as keys, and the hosts for each domain as comma-separated values.
# Example: domains["example.com"]="www,@,subdomain"
# "@": Represents the apex domain or the naked domain without any subdomain.
# "www,subdomain": Represents specific subdomains you want to update.
domains["domain1.ca"]="www,@,test"  # Replace "domain1.ca" with your domain name, and "www,@,test" with your actual hosts.
passwords["domain1.ca"]="domain1_password"  # Corresponding password for domain1.ca's DNS update API.

domains["domain2.ca"]="maison,www,ftp,sftp"  # Another example with multiple subdomains for domain2.ca.
passwords["domain2.ca"]="domain2_password"  # Corresponding password for domain2.ca's DNS update API.

# Specify the path to the logfile where the script's output will be logged.
logfile=logfile.log
# Enable or disable logging functionality. Set to 1 to enable logging, 0 to disable.
enable_logging=0

#### DO NOT MODIFY AFTER THIS LINE ####

# Function to log messages. It uses 'tee' to write to the console and to the logfile if logging is enabled.
log_message() {
    if [[ $enable_logging -eq 1 ]]; then
        echo "$@" | tee -a $logfile
    else
        echo "$@"
    fi
}

# Check if 'dig' command is available for DNS queries.
if ! command -v dig &> /dev/null; then
    log_message "dig could not be found, please install it."
    exit 1
fi

# Loop through each domain and its hosts to update their DNS records.
for domain in "${!domains[@]}"; do
    hosts=${domains[$domain]}
    password=${passwords[$domain]}  # Get the password for the current domain.
    for i in ${hosts//,/ }; do  # Split hosts by comma and iterate over them.
        log_message "-------------- $(date '+%Y-%m-%d %H:%M:%S') --------------"
        log_message "Processing host: $i for domain: $domain"
        
        # Adjust the query domain for 'dig' based on whether it's the apex domain or a subdomain.
        if [[ "$i" == "@" ]]; then
            query_domain="$domain"
        else
            query_domain="$i.$domain"
        fi

        # Use 'dig' to get the current IP address for the host/domain.
        current_ip=$(dig +short "$query_domain" | tail -n 1)  # Assuming the last line is the IP if multiple are returned.
        
        # Compare the current IP with the server's external IP and update DNS records if they differ.
        if [[ -z "$current_ip" ]]; then
            log_message "dig: couldn't get address for '$query_domain': not found. Skipping update."
        elif [[ $current_ip == $myip ]]; then
            log_message "Current IP for $query_domain is already up to date ($myip)."
        else
            # Call the DNS update API with the host, domain, password, and new IP address.
            response=$(curl -k -s "https://dynamicdns.park-your-domain.com/update?host=$i&domain=$domain&password=$password&ip=$myip")
            
            # Check for error count in the API response.
            errCount=$(echo $response | grep -oP '<ErrCount>\K[0-9]+')
            
            if [[ $errCount -gt 0 ]]; then
                log_message "Error encountered while updating $query_domain. Error count: $errCount"
            else
                log_message "Update successful for $query_domain."
            fi
        fi
        
        log_message ""  # Add an empty line for better readability in logs.
        # Pause to avoid overwhelming the server with too many requests in a short period.
        sleep 5
    done
done
