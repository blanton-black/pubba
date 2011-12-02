require 'sinatra/base'

require_relative 'pubba/errors'
require_relative 'pubba/site'

module Sinatra
  module Pubba
    def self.registered(app)
      app.settings.set :r18n, true unless app.settings.respond_to?(:r18n)
      app.settings.set :r18n_default, 'en' unless app.settings.respond_to?(:r18n_default)

      if app.settings.development? || app.settings.test?
        Site.configure(app)
      end
    end
  end # Pubba
end # Sinatra
