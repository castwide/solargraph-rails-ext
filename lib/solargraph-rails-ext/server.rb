require 'solargraph'
require 'eventmachine'
require 'bundler'
require 'json'
require 'solargraph-rails-ext/event_module'

module SolargraphRailsExt
  class Server
    include SolargraphRailsExt::ProcessMethods

    attr_reader :workspace

    def initialize workspace, port
      @workspace = workspace
      @port = port
      load_environment
    end

    def run
      if can_posix?
        Signal.trap("TERM") {
          STDERR.puts "Received TERM signal"
          EventMachine.stop
        }
      else
        Signal.trap("INT") {
          STDERR.puts "Received INT signal"
          EventMachine.stop
        }
      end
      EventMachine.run {
        EventMachine.start_server 'localhost', @port, SolargraphRailsExt::EventModule
      }
    end

    private

    def load_environment
      begin
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
      rescue Exception => e
        STDERR.puts "Error loading Rails environment: #{e}"
      end
    end
  end
end
