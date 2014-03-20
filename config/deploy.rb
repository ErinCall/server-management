lock '3.1.0'

set :application, 'andrewlorente'
set :repo_url, 'git@github.com:AndrewLorente/andrewlorente.git'
set :scm, :git

set :deploy_to, '/u/apps/andrewlorente'

namespace :deploy do
  task :compile do
    on roles(:all) do
      within release_path do
        execute './build.sh', as: 'andrewlorente'
      end
    end
  end
end

namespace :deploy do
  task :restart do
    on roles(:all) do
      sudo('initctl', 'restart', 'andrewlorente')
    end
  end
end

after 'deploy:updated', 'deploy:compile'
after 'deploy:symlink:release', 'deploy:restart'

namespace :puppet do
  set :puppet_parameters, 'puppet/manifests/site.pp'
  set :puppet_lib, "#{fetch(:puppet_destination)}/puppet/modules"
end
