require 'solargraph'
require 'solargraph-rails-ext/live_plugin'
require 'bundler'

class Solargraph::LiveMap
  install SolargraphRailsExt::LivePlugin
end
