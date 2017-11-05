require 'thread'
require 'socket'
require 'json'

module SolargraphRailsExt
  class LivePlugin
    include Solargraph::ServerMethods

    attr_reader :workspace

    def initialize workspace
      @workspace = workspace
      @cache = {}
      @port = available_port
      at_exit { close }
      open
    end

    def open
      @job = spawn("solargraph-rails-ext", workspace, @port.to_s) if @job.nil?
    end

    def close
      Process.kill("KILL", @job) unless @job.nil?
      @job = nil
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
