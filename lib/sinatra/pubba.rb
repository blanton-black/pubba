require 'sinatra/base'

require_relative 'pubba/errors'
require_relative 'pubba/site'
require_relative 'pubba/html/helpers'

module Sinatra
  module Pubba
    def self.registered(app)
      if app.settings.development? || app.settings.test?
        Site.configure(app)

        app.before do
          app.settings.set :asset_id, ->{Time.now.strftime("%N")}
        end
      else
        app.settings.set :asset_id, asset_id
      end

      app.helpers Sinatra::Pubba::HTML::Helpers

    end

    def self.asset_id
      ENV['ASSET_ID'] || raise(ConfigurationError, "Required ENV[ASSET_ID] not defined")
    end
  end # Pubba
end # Sinatra
