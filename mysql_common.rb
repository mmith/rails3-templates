# Template for RoR app with common gems, plugins...
# it uses ActiveRecord and Mysql 

# gems 

gem 'mysql', :require => 'mysql'
gem 'acts_as_list'
gem 'prawn'
gem 'haml'
gem 's3'
gem 'devise'
gem 'state_machine'
gem 'will_paginate'
gem 'meta_search'
gem 'paperclip', '2.3.4'
gem 'ckeditor', '3.4.2.pre'
gem 'capistrano'
gem 'thin', :group => [:development, :test]
gem 'shoulda', :group => [:development, :test]
gem 'factory_girl_rails', :group => [:development, :test]
gem 'autotest', :group => [:development, :test]
gem 'rspec', '>=2.0.1', :group => [:development, :test]
gem 'rspec-rails', '>=2.0.1', :group => [:development, :test]

run "bundle install"

# plugins

plugin "dynamic_form", :git => "git://github.com/rails/dynamic_form.git"
plugin "production_chain", :git => "git://github.com/novelys/production_chain.git"

# templating

remove_file "app/views/layouts/application.html.erb"
create_file "app/views/layouts/application.html.haml"
remove_file "public/index.html"

# javascripts

run "rm public/javascripts/*.js"
get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
`curl http://github.com/rails/jquery-ujs/raw/master/src/rails.js -o public/javascripts/rails.js`

# stylesheets

run "mkdir public/stylesheets/sass"

# assets
run "mkdir public/system"

# database config file

database = <<-DATABASE
development:
  adapter: mysql
  host: localhost
  pool: 5
  timeout: 5000
  database: #{app_name}_development
  encoding: utf8
  username: 
  password:

test:
  adapter: mysql
  host: localhost
  pool: 5
  timeout: 5000
  database: #{app_name}_test
  encoding: utf8
  username: 
  password:
DATABASE

remove_file "config/database.yml"
create_file "config/database.example.yml", database
create_file "config/database.yml", database

# devise

run "rails g devise:install"

# rspec

run "rails g rspec:install"
run "rm -rf test"

remove_file "spec/spec_helper.rb"

spec_helper = <<-SPEC_HELPER
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda'
require "paperclip/matchers"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
  
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include Devise::TestHelpers, :type => :controller

end
SPEC_HELPER
create_file "spec/spec_helper.rb", spec_helper

# git

gitignore = <<-GITIGNORE
.bundle
*.swp
db/*.sqlite3
log/*.log
tmp/**/*
config/database.yml
coverage
public/system
GITIGNORE

create_file ".gitignore", gitignore

git :init
git :add => '.'
run "git commit -m 'initial commit'"


