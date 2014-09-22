require 'rubygems'
require 'bundler'
require 'json'

Bundler.require
require 'sinatra/config_file'
config_file 'config/redis.yml'

require './app'
run Sinatra::Application