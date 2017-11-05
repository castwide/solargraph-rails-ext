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
      @semaphore = Mutex.new
      @port = available_port
      @job = spawn("solargraph-rails-ext", workspace, @port.to_s)
      at_exit { Process.kill("KILL", @job) unless @job.nil? }
    end

    def close
      Process.kill("KILL", @job)
      @job = nil
    end

    def query namespace, root, scope, visibility
      s = TCPSocket.open('localhost', @port)
      s.puts({
        scope: scope, namespace: namespace, root: root, visibility: visibility
      }.to_json)
      data = s.gets
      return [] if data.nil?
      s.close
      JSON.parse(data)
    end
  end
end
