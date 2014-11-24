# Server Configuration

This is a set of ansible playbooks and a fabfile, for configuring the allserver and deploying the sites, respectively.

Install dependencies with `pip install -r requirements.txt`

Deploy sites with `fab deploy:$site`

Deploy configuration with `ansible-playbook site.yml --ask-vault-pass`.

The ansible playbooks assume they're pointed at an Ubuntu 14.04 server, configured for passwordless sudo with an `alorente` sudoer. The `Webserver` snapshot on DigitalOcean is sufficient; it includes sane iptables and fail2ban.

The gitlab server is a prepackaged DO droplet; I've customized it with a 13.10->14.04 upgrade and some SSL rule changes to make ssllabs happy.

The mailman server is also not managed; stupid mailman needs Apache.

## TODO

1. I think my snapshot leaves the IRC port closed
1. znc.conf
1. test fabfile against config-staging
1. stop pointing the ansible playbooks at config-staging in hosts.cfg
