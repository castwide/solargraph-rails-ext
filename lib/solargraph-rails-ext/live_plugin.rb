require 'thread'
require 'socket'
require 'json'

module SolargraphRailsExt
  class LivePlugin
    include Solargraph::ServerMethods
    include SolargraphRailsExt::ProcessMethods

    attr_reader :workspace

    def initialize workspace
      @workspace = workspace
      @cache = {}
      @port = available_port
      @thread = nil
      open
    end

    def open
      if @job.nil?
        STDERR.puts "Starting the server process on port #{@port}"
        if can_posix?
          @job = spawn("solargraph-rails-ext", workspace, @port.to_s)
        else
          @job = spawn("solargraph-rails-ext", workspace, @port.to_s, "<NUL", new_pgroup: true)
        end
        Process.detach(@job)
      end
    end

    def close
      unless @job.nil?
        STDERR.puts "Closing #{@job} (port #{@port})"
        if can_posix?
          Process.kill("TERM", @job)
        else
          Process.kill("INT", @job)
        end
        Process.wait(@job)
        @job = nil
      end
    end

    def query namespace, root, scope, visibility
      begin
        s = TCPSocket.open('localhost', @port)
        s.puts({
          scope: scope, namespace: namespace, root: root, visibility: visibility
        }.to_json)
        data = s.gets
        return [] if data.nil?
        s.close
        JSON.parse(data)
      rescue Errno::ECONNREFUSED => e
        STDERR.puts "The Rails live plugin is not ready yet."
        []
      end
    end
  end
end
