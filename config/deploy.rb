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

# Ensure that bundle is used for rake tasks
SSHKit.config.command_map[:rake] = "bundle exec rake"

lock '3.2.1'

# before 'deploy', 'rvm1:install:ruby'  # install/update Ruby
# before 'deploy', 'rvm1:install:gems'

set :application, 'phaph'
# We are only going to use a single stage: production
set :stages, ["production"]

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

end
