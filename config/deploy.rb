set :stages, %w(staging production temp)
set :default_stage, "staging"
require 'capistrano/ext/multistage'