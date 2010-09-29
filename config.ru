$: << File.join(File.dirname(__FILE__), 'lib')
require "timelapse"
use Timelapse
run Rack::Directory.new("public")
