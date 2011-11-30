set :stages, %w(staging production temp temp2 vplocal vpremote)
set :default_stage, "vpremote"
require 'capistrano/ext/multistage'

require "bundler/capistrano"

# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.
require "rvm/capistrano"