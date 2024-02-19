# Namecheap DNS Auto-Updater Script

This script is designed to automatically update DNS records for specified domains and subdomains on Namecheap, using the current external IP of the server it's run on. It supports multiple domains and subdomains, making it ideal for dynamic DNS updates.

## Features

- Automatically updates DNS records for multiple domains and hosts.
- Utilizes the current external IP address for updates.
- Configurable logging of operations.

## Prerequisites

- `curl` must be installed to fetch the external IP address.
- `dig` must be installed for DNS queries to verify current DNS record values.

## Configuration

Before running the script, you need to configure your domain information:

1. **Domains and Hosts:** Edit the script to include your domains and their respective hosts in the `domains` associative array. Use the format `domains["yourdomain.com"]="www,@,subdomain"` where `@` represents the root domain.

2. **Passwords:** Similarly, add your Namecheap Dynamic DNS passwords to the `passwords` associative array, matching them with their corresponding domains.

3. **Logging:** The script's logging behavior can be controlled by the `enable_logging` variable. Set it to `1` to enable logging to a file, or `0` to disable it. Configure the `logfile` variable with the desired path to your log file.

## Usage

To run the script, simply execute it from the command line:

```bash
./namecheap_dns_updater.sh
```

Ensure the script has execute permissions:

```bash
chmod +x namecheap_dns_updater.sh
```

## Automating with Crontab

To have the script run automatically at regular intervals, you can set up a cron job. For example, to run the script every hour, you would add the following line to your crontab:

```bash
0 * * * * /path/to/namecheap_dns_updater.sh
```

Edit your crontab with the `crontab -e` command and add the line above, adjusted with the correct path to the script.

## How It Works

The script performs the following operations:

1. Fetches the current external IP address of the server.
2. Iterates through each domain and host specified in the configuration.
3. Uses `dig` to check if the current DNS record matches the server's external IP.
4. If the IP address has changed, it calls the Namecheap API to update the DNS record.
5. Logs operations based on the logging configuration.

## Logging

If enabled, the script logs each operation, including successful updates and errors. This is useful for troubleshooting and verifying that DNS records are being updated as expected.

## Customization

Feel free to modify the script to suit your specific needs, such as adding error handling, notifications, or integrating with other systems.

## License

This script is provided "as is", without warranty of any kind. You are free to use, modify, and distribute it as you see fit.

## Contributing

Contributions to the script are welcome! Please feel free to submit pull requests or report any issues you encounter.
