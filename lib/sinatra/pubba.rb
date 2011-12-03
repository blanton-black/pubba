require 'sinatra/base'

require_relative 'pubba/errors'
require_relative 'pubba/site'

module Sinatra
  module Pubba
    def self.registered(app)
      if app.settings.development? || app.settings.test?
        Site.configure(app)
      end
    end
  end # Pubba
end # Sinatra
