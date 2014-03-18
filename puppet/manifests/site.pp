node default {
  user { 'andrewlorente':
    shell => '/bin/bash',
    home => '/home/andrewlorente',
    managehome => true,
    ensure => present,
  }

  ssh_authorized_key { 'andrewlorente_alorente':
    ensure => present,
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCkmkuFbxxKmsDiqUMH1X7PFS+EZfR6i7U/Xe0vociH41kA8ZBr6GQ5pXU/MYg8LlOqOnJnxSeScDGMyPMOEida+NsJGYwYHOablAJ9H9cD3uQG9gPZQEYEd8gRCUPwzK9o+80SPAq4YCM8/wttMtEXmqEUVZ5skbQsCEwh5kfsqDNd/b+xXwYYWhr1nPSt8jimvjViXlJ5D7LjoWThFEXztTKTmhOhc6UiKPDeXGsU28A/PuAXgnLQaxjoHk/7IFWFr52yclYo+xGBRb2GBYO6I20sjQK8IHDK5L+f/wufHAoJZsvLj0ekWUwN+NAFLKO8BHqp5XCpblk+V/3JKr6P',
    name => 'andrewlorente_alorente',
    type => 'ssh-rsa',
    user => 'andrewlorente',
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

  class {'nginx':
    nx_worker_processes => 1,
    nx_worker_connections => 1024,
    nx_client_max_body_size => '4G',
    nx_types_hash_max_size => 2048,
    nx_gzip => 'on',
  }
  nginx::resource::upstream { 'andrewlorente':
    ensure => present,
    members => [
      'localhost:8000 weight=1',
    ],
  }
  nginx::resource::location { 'andrewlorente':
    ensure => present,
    vhost => 'andrewlorente-nonssl.com',
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

  nginx::resource::vhost { 'andrewlorente-nonssl.com':
    ensure => present,
    server_names => ['andrewlorente.com'],
    listen_port => 80,
    force_ssl => false, #FIXME
    www_root => '/u/apps/andrewlorente/current/public',
  }

  # nginx::resource::vhost { 'andrewlorente.com':
  #   ensure => present,
  #   server_names => ['andrewlorente.com'],
  #   listen_port => 443,
  #   www_root => '/u/apps/andrewlorente/current/public',
  #   ssl => true,
  #   ssl_cert => '/etc/ssl/server.crt',
  #   ssl_key => '/etc/ssl/privatekey.pem',
  # }
}
