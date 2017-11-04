require 'solargraph'
require 'solargraph-rails-ext/version'
require 'bundler'

class Solargraph::LiveMap
  on_update do |api_map|
    if !api_map.workspace.nil? and api_map.required.include?('rails/all')
      Bundler.require
      require 'rails/all'
      rails_config = File.join(api_map.workspace, 'config', 'environment.rb')
      if File.file?(rails_config)
        unless require_relative(rails_config)
          Rails.application.reloader.reload!
        end
      end
    end
  end
end
