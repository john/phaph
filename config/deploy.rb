# do this for reals eventually (with deploy user):
# http://capistranorb.com/documentation/getting-started/installation/

# info about config files, symlinks, etc
# http://www.talkingquickly.co.uk/2014/01/deploying-rails-apps-to-a-vps-with-capistrano-v3/

# read this too:
# http://www.capistranorb.com/documentation/getting-started/flow/

# to use it:
# cap production deploy
# cap production deploy:stop

# https://github.com/capistrano/capistrano/wiki/Capistrano-Tasks

# mysql -h prod.cmjzuhmazvmn.us-west-2.rds.amazonaws.com -u root -pD0nkeyK0ng prod

# config valid only for Capistrano 3.1

lock '3.2.1'

before 'deploy', 'rvm1:install:ruby'  # install/update Ruby
before 'deploy', 'rvm1:install:gems'

set :application, 'phaph'
set :deploy_user, 'ubuntu'

set :scm, :git
set :repo_url, 'git@github.com:john/phaph.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/ubuntu/phaph'

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'start application'
  task :start do
    on roles(:all), in: :sequence, wait: 1 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      within release_path do
        execute :sudo, :passenger, "start --daemonize --port 80 --user ubuntu --user=ubuntu --environment production"
      end
    end
  end
  
  desc 'stop application'
  task :stop do
    on roles(:all), in: :sequence, wait: 1 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      within release_path do
        # execute :rvm, "use default" # rather, add this to .bashrc when provisioning server
        execute :sudo, :passenger, "stop --port 80"
      end
    end
  end

  # after :publishing, :restart
  #
  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #
  #     # anther example:
  #     # execute :chown, "-R :#{fetch(:group)} #{deploy_to} && chmod -R g+s #{deploy_to}"
  #   end
  # end

end

# 2.x syntax, but keep executable
# namespace :deploy do
#   task :start do
#     puts 'PHU'
#     run "cd #{current_path} && bundle exec passenger start --socket /tmp/passenger.socket --daemonize --environment production"
#   end
#
#   task :stop do
#     # run "cd #{current_path} && bundle exec passenger stop --pid-file tmp/pids/passenger.pid"
#     # run "cd #{current_path}; rvmsudo passenger stop --port 80"
#     execute "cd #{current_path}; rvmsudo passenger stop --port 80"
#   end
#
#   # 3.x
#   # namespace :deploy do
#   #   on roles :all do
#   #     execute :chown, "-R :#{fetch(:group)} #{deploy_to} && chmod -R g+s #{deploy_to}"
#   #   end
#   # end
#
#   # task :restart, :roles => :app, :except => { :no_release => true } do
#   #   run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
#   # end
# end

# # https://coderwall.com/p/-qmwew/run-rake-tasks-with-capistrano
# namespace :db do
#   desc "Rake db:create"
#   task :create do
#     rake "db:migrate"
#     # run "cd #{deploy_to}/current"
#     # run "bundle exec rake db:create RAILS_ENV=#{rails_env}"
#   end
# end
