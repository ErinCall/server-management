require 'rubygems'
require 'supply_drop'

set :application, "andrewlorente"
set :repository, "./.git"
set :scm, :git

role :web, "107.170.234.125"

set :user, "alorente"

set :puppet_parameters, 'puppet/manifests/site.pp'
set :puppet_lib, "#{puppet_destination}/puppet/modules"

load 'deploy'
