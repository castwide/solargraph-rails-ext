require 'thread'
require 'socket'
require 'json'

module SolargraphRailsExt
  class LivePlugin < Solargraph::Plugin::Runtime
    def post_initialize
      return unless using_rails?
      Bundler.with_clean_env do
        Dir.chdir api_map.workspace do
          @io = IO.popen('bundle exec solargraph-rails-ext', 'r+')
        end
      end
    end

    def get_methods namespace:, root:, scope:, with_private: false
      return [] unless using_rails?
      return [] if @io.nil?
      params = {
        namespace: namespace, root: root, scope: scope, with_private: false
      }
      @io.puts "#{params.to_json}"
      result = @io.gets
      JSON.parse(result)
    end

    def runtime?
      using_rails?
    end

    def using_rails?
      # @todo This a quick and dirty way to see if the workspace is a Rails
      # project. Investigate better methods.
      return false if api_map.nil?
      File.exist?(File.join api_map.workspace, 'bin', 'rails')
    end
  end
end
