#!/usr/bin/ruby

require 'fog'
require 'yaml'
require 'pry'

class Cloud < Thor
  class_option :region, :default => 'us-west-2'
  class_option :provision_username, :default => 'ubuntu'
  
end