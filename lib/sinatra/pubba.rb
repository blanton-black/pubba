require 'sinatra/base'
require 'psych'
require 'sprockets'

require_relative 'pubba/site'

module Sinatra
  module Pubba
    class << self
      def process_yaml
        yaml = Psych.load_file(settings.pubba_config)

        Site.global_configuration = yaml.delete("global")

        yaml.each do |page, config|
          Site.add_page(page, config)
        end
      end

      def registered(app)
        if settings.development? || settings.test?
          Site.configure(app)
          process_yaml
          Site.build(app)
        end
      end
    end # class block
  end
end
