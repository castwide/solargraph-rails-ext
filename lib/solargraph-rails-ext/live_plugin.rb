require 'thread'

module SolargraphRailsExt
  class LivePlugin
    attr_reader :workspace

    def initialize workspace
      @workspace = workspace
      @cache = {}
      @semaphore = Mutex.new
      @io = nil
      open
      at_exit { @io.close }
    end

    def open
      @semaphore.synchronize do
        @io = IO.popen("solargraph-rails-ext #{workspace}", "r+")
      end
    end

    def close
      @semaphore.synchronize do
        @io.close
      end
    end

    def reload
      @semaphore.synchronize do
        @cache.clear
      end
      close
      open
    end

    def query scope, namespace, root
      @semaphore.synchronize do
        #result = @cache[[scope, namespace, root]]
        #if result.nil?
          @io.puts "#{scope} #{namespace} #{root}"
          result = JSON.parse(@io.gets)
          #@cache[[scope, namespace, root]] = result
        #end
        result
      end
    end
  end
end
