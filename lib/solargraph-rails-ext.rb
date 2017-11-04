require 'solargraph'
require 'solargraph-rails-ext/live_plugin'
require 'bundler'

STDERR.puts "************** HERE"
class Solargraph::LiveMap
  install SolargraphRailsExt::LivePlugin
end
