require 'bundler'
Bundler.setup
Bundler.require
require 'rack/contrib/try_static'

use Rack::TryStatic,
  :urls => %w[/],
  :root => "_site",
  :try => ['.html', 'index.html', '/index.html'] # try these postfixes sequentially

run lambda { |env|
 [
   404, {'Content-Type' => 'text/html'},
   ['Not Found :(']
 ]
}
