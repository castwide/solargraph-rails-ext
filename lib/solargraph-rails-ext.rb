require 'solargraph'
require 'solargraph-rails-ext/version'
require 'bundler'

module SolargraphRailsExt
  autoload :LivePlugin,     'solargraph-rails-ext/live_plugin'
  autoload :Server,         'solargraph-rails-ext/server'
  autoload :EventModule,    'solargraph-rails-ext/event_module'
  autoload :ProcessMethods, 'solargraph-rails-ext/process_methods'
end

Solargraph::LiveMap.install SolargraphRailsExt::LivePlugin
