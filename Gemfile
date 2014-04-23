source 'http://ruby.taobao.org'
# source "http://rubygems.org"

# redmine core
gem "rails", "2.3.11"
gem 'rubytree', "0.5.2"
gem 'coderay', '~>0.9.7'
gem 'i18n', '0.4.2'
gem 'rake', '0.8.7'
gem 'mysql'

# customization
gem "spreadsheet"

group :development, :test do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano-ext'
  gem "capistrano_colors"
  gem 'rvm-capistrano'
  # gem 'mongrel_cluster', :lib => 'mongrel'
  gem 'shoulda', '~>2.10.3'
  gem 'edavis10-object_daddy'
  gem 'mocha'

  gem 'rspec', '~>2.7.0'
  gem 'rcov'
  gem 'ZenTest'
  gem 'autotest-rails'
  gem 'autotest-growl'
  # gem 'autotest-fsevent'
end

group :staging do
  gem 'mongrel_cluster'
end