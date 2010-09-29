$: << File.join(File.dirname(__FILE__), 'lib')
require "timelapse"
use Timelapse::App
run Rack::Directory.new("public")
