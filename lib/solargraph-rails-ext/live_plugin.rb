require 'thread'
require 'socket'
require 'json'

module SolargraphRailsExt
  class LivePlugin < Solargraph::Plugin::Base
    include Solargraph::ServerMethods
    include SolargraphRailsExt::ProcessMethods

    def post_initialize
      @port = available_port
      @thread = nil
    end

    def start
      return unless using_rails?
      if @job.nil?
        STDERR.puts "Starting the server process on port #{@port}"
        if can_posix?
          @job = spawn("solargraph-rails-ext", workspace, @port.to_s)
        else
          @job = spawn("solargraph-rails-ext", workspace, @port.to_s, "<NUL", new_pgroup: true)
        end
      end
    end

    def stop
      return unless using_rails?
      unless @job.nil?
        STDERR.puts "Closing #{@job} (port #{@port})"
        if can_posix?
          Process.kill("TERM", @job)
        else
          Process.kill("INT", @job)
        end
        @job = nil
      end
    end

    def get_methods namespace:, root:, scope:, with_private: false
      return respond_ok([]) unless using_rails?
      params = {
        scope: scope, namespace: namespace, root: root, with_private: with_private
      }
      puts params.inspect
      begin
        s = TCPSocket.open('localhost', @port)
        s.puts params.to_json
        data = s.gets
        s.close
        return respond_ok([]) if data.nil?
        respond_ok JSON.parse(data)
      rescue Errno::ECONNREFUSED => e
        STDERR.puts "The Rails live plugin is not ready yet."
        respond_err e
      end
    end

    def using_rails?
      # @todo This a quick and dirty way to see if the workspace is a Rails
      # project. Investigate better methods.
      File.exist?(File.join workspace, 'bin', 'rails')
    end
  end
end
