require 'config/deploy/capistrano_database'

set :application, "rezets"
set :db_name, 'rm'
set :db_user, 'rezets'
set :scm, :git
set :user, "arctarus"
set :use_sudo, false
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :repository,  "git@67.23.21.106:rezets"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :ssh_options, { :forward_agent => true }
set :deploy_to, "/home/arctarus/public_html/#{application}"

default_run_options[:pty] = true

# role :web, "67.23.21.106"                          # Your HTTP server, Apache/etc
# role :app, "67.23.21.106"                          # This may be the same as your `Web` server
# role :db,  "67.23.21.106", :primary => true        # This is where Rails migrations will run
# role :db,  "your slave db-server here"

server 'rezets.com', :app, :web, :db, :primary => true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
