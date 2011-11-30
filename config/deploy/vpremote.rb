set :application, "pcard"
set :deploy_to, "/usr/local/www/#{application}"
#set :use_sudo, true
set :use_sudo, false
set :user, "runner"
set :runner, "runner"
set :bundle_cmd, "bundle"
set :rvm_ruby_string, 'ree@rails2.3.11'
set :rvm_type, :user
# set :default_environment, {
#     # 'PATH' => "/usr/local/bin:/bin:/usr/bin:/bin:/<ruby-dir>/bin",
#     # 'GEM_HOME' => '<ruby-dir>/lib/ruby/gems/1.8',
#     # 'GEM_PATH' => '<ruby-dir>lib/ruby/gems/1.8',
#     # 'BUNDLE_PATH' => '/home/runner/.rvm/gems/ree-1.8.7-2011.03@global/bin/bundle'
# }

# Your EC2 instances. Use the ec2-xxx....amazonaws.com hostname, not
# any other name (in case you have your own DNS alias) or it won't
# be able to resolve to the internal IP address.
set :domain, "112.64.179.10"  #vpremote
# Whatever you set here will be taken set as the default RAILS_ENV value
# on the server. Your app and your hourly/daily/weekly/monthly scripts
# will run with RAILS_ENV set to this value.
set :rails_env, "production"

# NOTE: for some reason Capistrano requires you to have both the public and
# the private key in the same folder, the public key should have the
# extension ".pub".
ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/id_rsa"]

set :scm, :git
set :scm_verbose, true
set :branch, "v2"
#set :scm_user, 'alexchien'
#set :scm_passphrase, "alexgem"
set :repository,  "git@github.com:AlexChien/redmine.git"
set :deploy_via, :remote_cache


# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, domain
role :web, domain
#role :product, "192.168.1.1"
#role :pre_product, "192.168.1.2"
role :db,  domain, :primary => true

## Add mongrel cluster support ##
# require 'mongrel_cluster/recipes'
# set :mongrel_conf, "#{shared_path}/config/mongrel_cluster.yml"
# set :mongrel_user, "runner"


# add misc task here
namespace :deploy do
  desc "Generate database.yml and Create asset packages for production, minify and compress js and css files"
  after "deploy:update_code", :roles => [:web] do
    config_yml
    # app_config
    # asset_packager
  end

  # add soft link script for deploy
  desc "Symlink the upload directories"
  after "deploy:symlink", :roles => [:web] do
    ## create link for shared assets
    # run "#{release_path}/script/relink.sh #{shared_path}/assets #{release_path}/public/images/assets #{previous_release} #{release_name} assets"
    ## create link for mongrel cluster

    # backup_db
    # migrate
  end

  # customized tasks
  desc "Backup Mysql"
  task :backup_db, :roles => [:web] do
  run "#{shared_path}/script/mysql_backup.pl pcard_production:utf8 #{releases.last} "
  end

  desc "Migrate db"
  task :migrate, :roles => [:web] do
    # run "cd #{latest_release} && #{bundle_cmd} exec #{rake} db:migrate RAILS_ENV=#{rails_env} && #{bundle_cmd} exec #{rake} db:migrate_plugins RAILS_ENV=#{rails_env}"
    run "cd #{latest_release} && rake db:migrate RAILS_ENV=production"
    run "cd #{latest_release} && rake db:migrate_plugins RAILS_ENV=production"
  end

  desc "Generate Production database.yml"
  task :config_yml, :roles => [:web] do
    db_config = "#{shared_path}/config/database.yml.production"
    run "cp #{db_config} #{release_path}/config/database.yml"
    run "cp #{shared_path}/config/configuration.yml.production #{release_path}/config/configuration.yml"
  end

  desc "Create asset packages for production, minify and compress js and css files"
  task :asset_packager, :roles => [:web] do
    run <<-EOF
    cd #{release_path} && #{bundle_cmd} exec #{rake} RAILS_ENV=production asset:packager:build_all
    EOF
  end

  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  # more info about automatially update and incoporate REASON and UNTIL variable
  # check this out: http://www.letrails.cn/archives/customize-capistrano-maintenance-page
  namespace :web do
    task :disable do
      on_rollback { delete "#{shared_path}/system/maintenance.html" }
      maintenance = File.read("./public/maintenance.html")
      put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end

end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

after "deploy", "rvm:trust_rvmrc"

##For testing##

#namespace :develop do
#  desc "Set pre_product ENV"
#  task :settings, :roles => [:pre_product] do
#    set :rails_env,   "development"
#  end
#  desc "Test say hellp"
#  task :hello, :roles => [:pre_product] do
#    run "echo hello"
#  end
  ##run task##
  #########
#end
