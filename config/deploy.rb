# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'fwb'
set :repo_url, 'git@git.metabahn.net:client/fwb_backend.git'

set :deploy_to, '/var/apps/fwb'
set :scm, :git
# set :branch, :develop

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{.env config/database.yml config/rdf_database.yml}
set :linked_dirs, %w{log system public/static}

set :rbenv_ruby, '2.0.0-p451'
set :rack_env, :staging

namespace :deploy do

  desc 'Start application'
  task :start do
    on roles(:app) do
      execute "sudo service thin start"
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      execute "sudo service thin stop"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')

      execute "sudo service thin restart"
    end
  end

  after :publishing, :restart

  after :finishing, 'deploy:cleanup'

end
