#THINGS THAT MUST BE DONE MANUALLY CUZ I'M NOT LAZY ENOUGH TO AUTOMATE THEM:
# sudo cabal install --global cabal-install
# iptables rules
# fail2ban
# Deny password auth for ssh
# Install pip via https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py
# Create catsnap database
# Backups:
## curl get.rvm.io | sudo bash
## rvm install 2.0.0
## gem install astrails-safe --source http://gemcutter.org
## vi root.crontab astrails.conf


node default {
  package { "haskell-platform":
    ensure => installed,
  }
  package { "git":
    ensure => installed,
  }
  package { "libpq-dev":
    ensure => installed,
  }
  package { "postgresql-9.1":
    ensure => installed,
  }
  package { "postgresql-client-common":
    ensure => installed,
  }
  package { "znc":
    ensure => installed,
  }
  package { "libjpeg-dev":
    ensure => installed,
  }
  file { '/usr/lib/libjpeg.so':
   ensure => 'link',
   target => '/usr/lib/x86_64-linux-gnu/libjpeg.so',
  }
  file { '/usr/lib/freetype.so':
   ensure => 'link',
   target => '/usr/lib/x86_64-linux-gnu/freetype.so',
  }
  file { '/usr/lib/libz.so':
   ensure => 'link',
   target => '/usr/lib/x86_64-linux-gnu/libz.so',
  }
  package { "python-dev":
    ensure => installed,
  }

  user { 'andrewlorente':
    shell => '/bin/bash',
    home => '/home/andrewlorente',
    managehome => true,
    ensure => present,
  }

  user { 'bloge':
    shell => '/bin/bash',
    home => '/home/bloge',
    managehome => true,
    ensure => present,
  }

  user { 'catsnap':
    shell => '/bin/bash',
    home => '/home/catsnap',
    managehome => true,
    ensure => present,
  }

  user { 'identity':
    shell => '/bin/bash',
    home => '/home/identity',
    managehome => true,
    ensure => present,
  }

  ssh_authorized_key { 'andrewlorente_alorente':
    ensure => present,
    key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6q+NIMbgehuTQN/LymntUtqorU3qNqN05yXZKwgRYDapn8XLgJA3OGmfEcaMyK+0ry/US4Kl9fTk5H16YZ/ZTRbJfssVvbWSDTBP/ho1hhjpLEgHD3lmhuO27reypg5aawJpQBFzLKHDBUZ/sUOLawP9LVRiPp2Ve2mG+K3R+k6U9b2MaEIF3cfp3FU20wex/M9pce4a+PjmdM4Yvuy0Mn4MfuhpoLRfEBmI1qlwrqvCTeMK4OGufEQXpe+KmjBovMTKx142lm6XSTJ2JRtuOrSGqUaFFyzHSUSjLGwl1zjdjOafsJZvclyTt/dDB1RmX/Fr2YYk+EZN/a33agDJTQ==',
    name => 'andrewlorente_alorente',
    type => 'ssh-rsa',
    user => 'andrewlorente',
  }

  ssh_authorized_key { 'bloge_alorente':
    ensure => present,
    key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6q+NIMbgehuTQN/LymntUtqorU3qNqN05yXZKwgRYDapn8XLgJA3OGmfEcaMyK+0ry/US4Kl9fTk5H16YZ/ZTRbJfssVvbWSDTBP/ho1hhjpLEgHD3lmhuO27reypg5aawJpQBFzLKHDBUZ/sUOLawP9LVRiPp2Ve2mG+K3R+k6U9b2MaEIF3cfp3FU20wex/M9pce4a+PjmdM4Yvuy0Mn4MfuhpoLRfEBmI1qlwrqvCTeMK4OGufEQXpe+KmjBovMTKx142lm6XSTJ2JRtuOrSGqUaFFyzHSUSjLGwl1zjdjOafsJZvclyTt/dDB1RmX/Fr2YYk+EZN/a33agDJTQ==',
    name => 'bloge_alorente',
    type => 'ssh-rsa',
    user => 'bloge',
  }

  ssh_authorized_key { 'catsnap_alorente':
    ensure => present,
    key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6q+NIMbgehuTQN/LymntUtqorU3qNqN05yXZKwgRYDapn8XLgJA3OGmfEcaMyK+0ry/US4Kl9fTk5H16YZ/ZTRbJfssVvbWSDTBP/ho1hhjpLEgHD3lmhuO27reypg5aawJpQBFzLKHDBUZ/sUOLawP9LVRiPp2Ve2mG+K3R+k6U9b2MaEIF3cfp3FU20wex/M9pce4a+PjmdM4Yvuy0Mn4MfuhpoLRfEBmI1qlwrqvCTeMK4OGufEQXpe+KmjBovMTKx142lm6XSTJ2JRtuOrSGqUaFFyzHSUSjLGwl1zjdjOafsJZvclyTt/dDB1RmX/Fr2YYk+EZN/a33agDJTQ==',
    name => 'catsnap_alorente',
    type => 'ssh-rsa',
    user => 'catsnap',
  }

  ssh_authorized_key { 'identity_alorente':
    ensure => present,
    key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6q+NIMbgehuTQN/LymntUtqorU3qNqN05yXZKwgRYDapn8XLgJA3OGmfEcaMyK+0ry/US4Kl9fTk5H16YZ/ZTRbJfssVvbWSDTBP/ho1hhjpLEgHD3lmhuO27reypg5aawJpQBFzLKHDBUZ/sUOLawP9LVRiPp2Ve2mG+K3R+k6U9b2MaEIF3cfp3FU20wex/M9pce4a+PjmdM4Yvuy0Mn4MfuhpoLRfEBmI1qlwrqvCTeMK4OGufEQXpe+KmjBovMTKx142lm6XSTJ2JRtuOrSGqUaFFyzHSUSjLGwl1zjdjOafsJZvclyTt/dDB1RmX/Fr2YYk+EZN/a33agDJTQ==',
    name => 'identity_alorente',
    type => 'ssh-rsa',
    user => 'identity',
  }

  file { ['/u', '/u/apps']:
    ensure => 'directory',
    owner => 'root',
    group => 'root',
    mode => '0644'
  }

  file { [
      '/u/apps/andrewlorente',
      '/u/apps/andrewlorente/shared/',
      '/u/apps/andrewlorente/shared/pids',
      '/u/apps/andrewlorente/shared/log',
    ]:
    ensure => 'directory',
    owner => 'andrewlorente',
    group => 'andrewlorente',
    mode => '0644'
  }

  file { [
      '/u/apps/bloge',
      '/u/apps/bloge/releases',
      '/u/apps/bloge/shared/',
      '/u/apps/bloge/shared/pids',
      '/u/apps/bloge/shared/log',
    ]:
    ensure => 'directory',
    owner => 'bloge',
    group => 'bloge',
    mode => '0644'
  }

  file { [
      '/u/apps/catsnap',
      '/u/apps/catsnap/releases',
      '/u/apps/catsnap/shared/',
      '/u/apps/catsnap/shared/pids',
      '/u/apps/catsnap/shared/log',
    ]:
    ensure => 'directory',
    owner => 'catsnap',
    group => 'catsnap',
    mode => '0644'
  }

  file { [
      '/u/apps/identity',
      '/u/apps/identity/releases',
      '/u/apps/identity/shared/',
      '/u/apps/identity/shared/pids',
      '/u/apps/identity/shared/log',
    ]:
    ensure => 'directory',
    owner => 'identity',
    group => 'identity',
    mode => '0644'
  }

  class {'nginx':
    nx_worker_processes => 1,
    nx_worker_connections => 1024,
    nx_client_max_body_size => '4G',
    nx_types_hash_max_size => 2048,
    nx_server_names_hash_bucket_size => 64,
    nx_gzip => 'on',
  }
  nginx::resource::upstream { 'andrewlorente':
    ensure => present,
    members => [
      'localhost:8000 weight=1',
    ],
  }
  nginx::resource::upstream { 'bloge':
    ensure => present,
    members => [
      'localhost:8001 weight=1',
    ],
  }
  nginx::resource::upstream { 'catsnap':
    ensure => present,
    members => [
      'localhost:5000 weight=1',
    ],
  }
  nginx::resource::upstream { 'identity':
    ensure => present,
    members => [
      'localhost:5001 weight=1',
    ],
  }

  nginx::resource::location { 'andrewlorente':
    ensure => present,
    vhost => 'andrewlorente.com',
    location => '/',
    match_type => '~',
    proxy => 'http://andrewlorente',
    proxy_set_headers => {
      'REMOTE_ADDR' => '$remote_addr',
      'HTTP_HOST' => '$http_host',
      'Host' => '$host',
      'X-Forwarded-Proto' => '$scheme',
    },
  }
  nginx::resource::location { 'bloge':
    ensure => present,
    vhost => 'blog.andrewlorente.com',
    location => '/',
    match_type => '~',
    proxy => 'http://bloge',
    proxy_set_headers => {
      'REMOTE_ADDR' => '$remote_addr',
      'HTTP_HOST' => '$http_host',
      'Host' => '$host',
      'X-Forwarded-Proto' => '$scheme',
    },
  }
  nginx::resource::location { 'catsnap':
    ensure => present,
    vhost => 'catsnap.andrewlorente.com',
    location => '/',
    match_type => '~',
    proxy => 'http://catsnap',
    proxy_set_headers => {
      'REMOTE_ADDR' => '$remote_addr',
      'HTTP_HOST' => '$http_host',
      'Host' => '$host',
      'X-Forwarded-Proto' => '$scheme',
    },
  }
  nginx::resource::location { 'identity':
    ensure => present,
    vhost => 'id.andrewlorente.com',
    location => '/',
    match_type => '~',
    proxy => 'http://identity',
    proxy_set_headers => {
      'REMOTE_ADDR' => '$remote_addr',
      'HTTP_HOST' => '$http_host',
      'Host' => '$host',
      'X-Forwarded-Proto' => '$scheme',
    },
  }

  nginx::resource::vhost { 'andrewlorente-nonssl.com':
    ensure => present,
    server_names => ['andrewlorente.com'],
    listen_port => 80,
    force_ssl => true,
    www_root => '/u/apps/andrewlorente/current/static',
  }
  nginx::resource::vhost { 'blog.andrewlorente-nonssl.com':
    ensure => present,
    server_names => ['blog.andrewlorente.com'],
    listen_port => 80,
    force_ssl => true,
    www_root => '/u/apps/bloge/current/static',
  }
  nginx::resource::vhost { 'catsnap.andrewlorente-nonssl.com':
    ensure => present,
    server_names => ['catsnap.andrewlorente.com'],
    listen_port => 80,
    force_ssl => true,
    www_root => '/u/apps/catsnap/current/static',
  }
  nginx::resource::vhost { 'id.andrewlorente-nonssl.com':
    ensure => present,
    server_names => ['id.andrewlorente.com'],
    listen_port => 80,
    force_ssl => true,
    www_root => '/u/apps/identity/current/static',
  }

  nginx::resource::vhost { 'andrewlorente.com':
    ensure => present,
    server_names => ['andrewlorente.com'],
    listen_port => 443,
    www_root => '/u/apps/andrewlorente/current/static',
    ssl => true,
    ssl_cert => '/etc/ssl/STAR_andrewlorente_com.chained.crt',
    ssl_key => '/etc/ssl/andrewlorente.com.key',
  }
  nginx::resource::vhost { 'blog.andrewlorente.com':
    ensure => present,
    server_names => ['blog.andrewlorente.com'],
    listen_port => 443,
    www_root => '/u/apps/bloge/current/static',
    ssl => true,
    ssl_cert => '/etc/ssl/STAR_andrewlorente_com.chained.crt',
    ssl_key => '/etc/ssl/andrewlorente.com.key',
  }
  nginx::resource::vhost { 'catsnap.andrewlorente.com':
    ensure => present,
    server_names => ['catsnap.andrewlorente.com'],
    listen_port => 443,
    www_root => '/u/apps/catsnap/current/static',
    ssl => true,
    ssl_cert => '/etc/ssl/STAR_andrewlorente_com.chained.crt',
    ssl_key => '/etc/ssl/andrewlorente.com.key',
  }
  nginx::resource::vhost { 'id.andrewlorente.com':
    ensure => present,
    server_names => ['id.andrewlorente.com'],
    listen_port => 443,
    www_root => '/u/apps/identity/current/static',
    ssl => true,
    ssl_cert => '/etc/ssl/STAR_andrewlorente_com.chained.crt',
    ssl_key => '/etc/ssl/andrewlorente.com.key',
  }


  file { 'andrewlorente-upstart':
    path => '/etc/init/andrewlorente.conf',
    ensure => file,
    # Hardcoding /tmp/supply_drop like this is crappy. I don't know
    # what I should do instead, though. :(
    source => 'file:///tmp/supply_drop/puppet/manifests/andrewlorente.conf',
    mode => 'a=r,u+w',
    owner => 'root',
    group => 'root',
  }
  file { 'bloge-upstart':
    path => '/etc/init/bloge.conf',
    ensure => file,
    # Hardcoding /tmp/supply_drop like this is crappy. I don't know
    # what I should do instead, though. :(
    source => 'file:///tmp/supply_drop/puppet/manifests/bloge.conf',
    mode => 'a=r,u+w',
    owner => 'root',
    group => 'root',
  }
  file { 'catsnap-upstart':
    path => '/etc/init/catsnap.conf',
    ensure => file,
    # Hardcoding /tmp/supply_drop like this is crappy. I don't know
    # what I should do instead, though. :(
    source => 'file:///tmp/supply_drop/puppet/manifests/catsnap.conf',
    mode => 'a=r,u+w',
    owner => 'root',
    group => 'root',
  }
  file { 'identity-upstart':
    path => '/etc/init/identity.conf',
    ensure => file,
    # Hardcoding /tmp/supply_drop like this is crappy. I don't know
    # what I should do instead, though. :(
    source => 'file:///tmp/supply_drop/puppet/manifests/identity.conf',
    mode => 'a=r,u+w',
    owner => 'root',
    group => 'root',
  }
}
