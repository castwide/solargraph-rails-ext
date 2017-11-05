require 'solargraph'
require 'eventmachine'
require 'bundler'
require 'json'
require 'solargraph-rails-ext/event_module'

module SolargraphRailsExt
  class Server
    attr_reader :workspace

    def initialize workspace, port
      @workspace = workspace
      @port = port
      load_environment
    end

    def run
      EventMachine.run {
        EventMachine.start_server 'localhost', @port, SolargraphRailsExt::EventModule
      }
    end

    private

    def load_environment
      Dir.chdir workspace
      Bundler.with_original_env do
        ENV['BUNDLE_GEMFILE'] = File.join(workspace, 'Gemfile')
        Bundler.reset!
        Bundler.require
        rails_config = File.join(workspace, 'config', 'environment.rb')
        if File.file?(rails_config)
          require_relative(rails_config)
        end
      end
    end
  end
end
