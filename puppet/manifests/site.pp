#THINGS THAT MUST BE DONE MANUALLY CUZ I'M NOT LAZY ENOUGH TO AUTOMATE THEM:
# sudo cabal install --global cabal-install
# iptables rules
# fail2ban
# Deny password auth for ssh


node default {
  package { "haskell-platform":
    ensure => installed,
  }

  package { "git":
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

  file { ['/u', '/u/apps']:
    ensure => 'directory',
    owner => 'root',
    group => 'root',
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
}
