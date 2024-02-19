#!/bin/bash

# Script to configure domains and passwords for the dynamic DNS update script

echo "Configuration for dynamic DNS update script"
echo "Please follow the prompts to enter your domain information."

# Initialize empty associative arrays for domains and passwords
declare -A domains
declare -A passwords

# Function to add domain and associated hosts
add_domain() {
    local domain
    read -p "Enter domain name (e.g., example.com): " domain
    local hosts
    read -p "Enter hosts for $domain as comma-separated values (e.g., www,@,subdomain): " hosts
    domains["$domain"]="$hosts"
}

# Function to add password for a domain
add_password() {
    local domain=$1
    local password
    read -p "Enter password for $domain: " password
    passwords["$domain"]="$password"
}

# Ask user how many domains they wish to configure
read -p "How many domains do you wish to configure? " num_domains

for (( i=1; i<=num_domains; i++ ))
do
    echo "Configuring domain $i"
    add_domain
done

# Add passwords for each domain
for domain in "${!domains[@]}"; do
    echo "Adding password for $domain"
    add_password "$domain"
done

# Generate the configuration part of the script
echo "Generating configuration..."
echo ""
echo "# Domains and passwords configuration"
for domain in "${!domains[@]}"; do
    echo "domains[\"$domain\"]=\"${domains[$domain]}\""
    echo "passwords[\"$domain\"]=\"${passwords[$domain]}\""
done

echo ""
echo "Configuration generated. Please copy and paste the above output into your dynamic DNS update script."

