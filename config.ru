# config.ru
require 'bundler'
Bundler.require

require 'opal'
require 'sinatra'

set :appname, 'hieraviz'

Opal::Processor.source_map_enabled = true
opal = Opal::Server.new {|s|
  s.append_path 'app'
  s.main = 'home'
  s.debug = true
}

map opal.source_maps.prefix do
  run opal.source_maps
end rescue nil

map '/assets' do
  run opal.sprockets
end

get '/' do
  <<-HTML
    <!doctype html>
    <html>
      <head>
        <title>Hieraviz</title>
        <link rel="stylesheet" href="site.css" />
        <script src="/assets/home.js"></script>
        <script>#{Opal::Processor.load_asset_code(opal.sprockets, "home.js")}</script>
      </head>
      <body>
      <h1>test</h1>
        <div id="content"></div>
      </body>
    </html>
  HTML
end

run Sinatra::Application