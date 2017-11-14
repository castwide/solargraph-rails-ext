module SolargraphRailsExt
  class Process < Solargraph::Plugin::Process
    def post_initialize
      STDERR.puts "Preparing Rails in #{Dir.pwd}"
      Bundler.with_clean_env do
        ENV['BUNDLER_GEMFILE'] = File.join(Dir.pwd, 'Gemfile')
        Bundler.reset!
        rails_config = File.join(Dir.pwd, 'config', 'application.rb')
        if File.file?(rails_config)
          require_relative(rails_config)
        end
      end
    end
  end
end
