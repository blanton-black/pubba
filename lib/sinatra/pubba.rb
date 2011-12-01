require 'sinatra/base'

require_relative 'pubba/site'

module Sinatra
  module Pubba
    def self.registered(app)
      if settings.development? || settings.test?
        Site.configure(app)
      end
    end
  end
end
