set :application, "domain_planner"
set :repository,  "git@github.com:joshuamiller/domain_planner.git"
set :ssh_options, { :forward_agent => true }

set :scm, :git
set :branch, 'master'

task :dev do
  role :web, "virtualplanner"                          # Your HTTP server, Apache/etc
  role :app, "virtualplanner"
  role :db,  "virtualplanner", :primary => true # This is where Rails migrations will run
end

task :production do
  role :web, "linode.edplans.com"                          # Your HTTP server, Apache/etc
  role :app, "linode.edplans.com"
  role :db,  "linode.edplans.com", :primary => true # This is where Rails migrations will run
end

set :user, "deploy"
set :deploy_to, "/home/apps/#{application}"
default_run_options[:shell] = '/bin/bash --login'

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

require 'bundler/capistrano'
set :bundle_flags, "--deployment --binstubs"
set :bundle_without, [:test, :development, :deploy]

namespace :deploy do
  task :start do
    run "sudo sv up domain_planner"
  end
  task :stop do
    run "sudo sv down domain_planner"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo sv restart domain_planner"
  end
  task :precompile do
    run "cd #{ current_path } && RAILS_ENV=production bundle exec rake assets:precompile"
  end
  desc "Load the initial schema - it will WIPE your database, use with care"
  task :db_schema_load, :roles => :db, :only => { :primary => true } do
    puts <<-EOF
 
************************** WARNING ***************************
If you type [yes], rake db:schema:load will WIPE your database
any other input will cancel the operation.
**************************************************************
 
EOF
    answer = Capistrano::CLI.ui.ask "Are you sure you want to WIPE your database?: "
    if answer == 'yes'
      run "cd #{current_path} && RAILS_ENV=production bundle exec rake db:schema:load"
    else
      puts "Cancelled."
    end
  end
end

namespace :setup do
  desc "Create an admin user"
  task :admin do
    run "cd #{ current_path } && RAILS_ENV=production bundle exec rake edplans:admin[david@edplans.com]"
  end
end
  
after "deploy" do
  run "cd #{ current_path } && RAILS_ENV=production bundle exec rake assets:precompile"
end
