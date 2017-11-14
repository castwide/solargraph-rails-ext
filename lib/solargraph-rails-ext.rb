require 'solargraph'
require 'solargraph-rails-ext/version'
require 'bundler'

module SolargraphRailsExt
  autoload :LivePlugin,     'solargraph-rails-ext/live_plugin'
  autoload :Process,        'solargraph-rails-ext/process'
end

Solargraph::LiveMap.install SolargraphRailsExt::LivePlugin
