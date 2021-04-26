# Server Configuration

This is a set of ansible playbooks and a fabfile, for configuring the allserver and deploying the sites, respectively.

Install dependencies with `pip install -r requirements.txt`

Deploy sites with `fab deploy:$site`

Deploy configuration with `ansible-playbook site.yml`.

The ansible playbooks assume they're pointed at an Ubuntu 14.04 server, configured for passwordless sudo with an `ecall` sudoer. The `webserver2017` snapshot on DigitalOcean is sufficient; it includes sane iptables and fail2ban.

The gitlab server is a prepackaged DO droplet; I've customized it with a 13.10->14.04 upgrade and some SSL rule changes to make ssllabs happy.

The mailman server is also not managed; stupid mailman needs Apache.

# SSL Renewal

1. Generate a CSR: On the server, run `sudo openssl req -out $SITE_erincall_com_$YEAR.csr -subj '/C=US/ST=OR/O=Erin Call/CN=erincall.com' -key $SITE_erincall_com.key -new`.
    * The `$SITE` and `$YEAR` affixes for the `.csr` file aren't mandatory, but they help with keeping track of what's going on.
    * Remember to add the subdomain to the `CN` part of the `-subj` argument!
1. Follow the CSR-upload process through Namecheap
1. Extract the `.zip` file they send. Add the new certificate _and the certificate chain_ (from the `.ca-bundle` file) to `ssl_certificates.yml`. The bundle will be the same for each site, but it does seem to change from year to year.
1. Deploy the new configuration.
1. Profit!
