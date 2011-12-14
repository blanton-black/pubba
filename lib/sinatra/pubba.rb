require 'sinatra/base'

require_relative 'pubba/errors'
require_relative 'pubba/site'
require_relative 'pubba/html/helpers'

module Sinatra
  module Pubba
    def self.registered(app)
      Site.configure(app)

      app.helpers Sinatra::Pubba::HTML::Helpers
    end
  end # Pubba
end # Sinatra
