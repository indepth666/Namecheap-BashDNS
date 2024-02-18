# Namecheap-BashDNS

A simple Bash script for automating DNS updates on Namecheap domains.

## Introduction

This script allows for easy and automated Dynamic DNS updates for Namecheap domains using Bash. It's designed for systems that do not have a static IP address and need to update their DNS records periodically.

## Features

- Supports multiple hosts within a single domain.
- Securely updates DNS records with your current IP address.
- Configurable update intervals.

## Prerequisites

Before you begin, ensure you have the following:
- A Namecheap account with a domain set up for dynamic DNS.
- `curl` installed on your system.

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/indepth666/Namecheap-BashDNS
   ```
2. Navigate to the script directory:
   ```
   cd Namecheap-BashDNS
   ```
3. Make the script executable:
   ```
   chmod +x namecheap_dns_updater.sh
   ```

## Configuration

Edit `namecheap_dns_updater.sh` with your domain details:
- `mydomain`: Your domain name.
- `myhost`: The host records you wish to update, separated by commas.
- `password`: Your dynamic DNS password from Namecheap.

## Usage

Run the script manually with:
```
./namecheap_dns_updater.sh
```

Or set up a cron job for automated updates:
```
*/5 * * * * /path/to/namecheap_dns_updater.sh
```

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
