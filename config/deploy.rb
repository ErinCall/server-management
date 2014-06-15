lock '3.1.0'

namespace :puppet do
  set :puppet_parameters, 'puppet/manifests/site.pp'
  set :puppet_lib, "#{fetch(:puppet_destination)}/puppet/modules"
  set :puppet_excludes, %w(.git dist test/dist)
end
