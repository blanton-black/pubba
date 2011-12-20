require 'sinatra/base'
require 'rack/statica_server'

require_relative 'pubba/errors'
require_relative 'pubba/site'
require_relative 'pubba/html/helpers'

module Sinatra
  module Pubba
    def self.registered(app)
      unless app.settings.test?
        use Rack::StaticaServer
      end

      Site.configure(app)

      app.helpers Sinatra::Pubba::HTML::Helpers
    end
  end # Pubba
end # Sinatra
