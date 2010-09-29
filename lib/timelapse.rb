require 'sinatra/base'
require 'fileutils'
require 'erb'
require 'yaml'

module Timelapse
  ROOT_PATH = File.expand_path('../../', __FILE__)
  autoload :Helpers, 'timelapse/helpers'
  autoload :Images, 'timelapse/images'
  autoload :App, 'timelapse/app'
end
