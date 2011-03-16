#bundler integration
require "bundler/capistrano"

#rvm integration
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, 'ree'
set :rvm_type, :user

set :application, "medusa"

# name of the user who will own this application on the server 
set :user, "medusa-hydra"
set :use_sudo, false

# SVN repository from which to check out the code
set :scm, :git
set :repository, "git://github.com/medusa-project/medusa.git"
set :branch, :master
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/services/medusa-hydra/medusa-capistrano"

#set up specific to testing server
task :staging do
  set :domain, "dagda.grainger.uiuc.edu"
  role :app, domain
  role :web, domain
  role :db,  domain, :primary => true

end

#set up specific to production server
task :production do
  set :domain, 'the.production.server'
  role :app, domain
  role :web, domain
  role :db,  domain, :primary => true
end

set :rails_env, :production

# ========================
# For mod_rails apps
# ========================


namespace :deploy do
  task :start, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
  
  task :restart, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
  
  task :reindex, :roles => :app do
    run "cp #{deploy_to}/current/vendor/plugins/blacklight/config/initializers/blacklight_config.rb #{deploy_to}/current/config/initializers/blacklight_config.rb"
    # this next step shouldn't be necessary for rails 2.3, and yet the installation on polaris.lib won't 
    # run without it
    run "ln -nfs #{deploy_to}/current/vendor/plugins/blacklight/app/controllers/application_controller.rb #{deploy_to}/current/vendor/plugins/blacklight/app/controllers/application.rb"
    
    # reindex the data
    run "cd #{deploy_to}/current; rake solr:marc:index MARC_FILE=/usr/local/projects/data/test_data.utf8.mrc SOLR_WAR_PATH=/usr/local/projects/solr/solr.war CONFIG_PATH=#{deploy_to}/current/vendor/plugins/blacklight/config/SolrMarc/demoserver.properties"
    run "cd #{deploy_to}/current; rake app:index:ead_dir FILE=/usr/local/projects/data/ead/*.xml"
  end

# This assumes that your database.yml file is NOT in subversion,
# but instead is in your deploy_to/shared directory. Database.yml
# files should *never* go into subversion for security reasons.
  task :link_config do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/solr.yml #{release_path}/config/solr.yml"
    run "ln -nfs #{deploy_to}/shared/config/fedora.yml #{release_path}/config/fedora.yml"
  end

end

after 'deploy:update_code', 'deploy:link_config'
after 'deploy:symlink', 'deploy:reindex'
