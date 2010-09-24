require "timelapse"
use Timelapse
run Rack::Directory.new("public")
