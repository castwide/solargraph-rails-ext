require 'thread'
require 'socket'
require 'json'

module SolargraphRailsExt
  class LivePlugin < Solargraph::Plugin::Runtime
    def post_initialize
      self.executable = 'solargraph-rails-ext' if using_rails?
      super
    end

    def using_rails?
      # @todo This a quick and dirty way to see if the workspace is a Rails
      # project. Investigate better methods.
      return false if api_map.nil? or api_map.workspace.nil?
      File.exist?(File.join api_map.workspace, 'bin', 'rails')
    end

    protected

    def load_environment
      super unless using_rails?
    end
  end
end
