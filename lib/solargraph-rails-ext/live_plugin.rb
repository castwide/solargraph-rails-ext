require 'thread'
require 'socket'

module SolargraphRailsExt
  class LivePlugin
    attr_reader :workspace

    def initialize workspace
      @workspace = workspace
      @cache = {}
      @semaphore = Mutex.new
      @job = spawn("solargraph-rails-ext", workspace)
      at_exit { Process.kill("KILL", @job) unless @job.nil? }
    end

    def close
      Process.kill("KILL", @job)
      @job = nil
    end

    def query scope, namespace, root
      s = TCPSocket.open('localhost', 80801)
      s.puts "#{scope} #{namespace} #{root}"
      data = s.gets
      return [] if data.nil?
      s.close
      JSON.parse(data)
    end
  end
end
