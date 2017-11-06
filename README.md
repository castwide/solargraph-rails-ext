# solargraph-rails-ext

An extension to add the Rails runtime environment to Solargraph.

*This project is in early development.*

## Testing in VS Code

You can try Rails support in Visual Studio Code as follows:

* Make sure the [Solargraph extension](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph) is installed
* Open a folder containing a Rails project in VS Code
* Add the following code to the Gemfile:
    group :development do
      gem 'solargraph', github: 'castwide/solargraph'
      gem 'solargraph-rails-ext', github: 'castwide/solargraph-rails-ext'
    end
* Add the following to Workspace Settings:
    "solargraph.useBundler": true
* Open one of the projects' Ruby files.
* Start typing code. Example: `Rails.` should provide completion suggestions.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
