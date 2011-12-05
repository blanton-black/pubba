require 'psych'

module Sinatra
  module Pubba
    module Assets
      class Configuration
        attr_reader :yaml

        def initialize(config_file)
          @yaml = Psych.load_file(config_file)
        end

        def global_config!
          yaml.delete("global") || {}
        end

        def process
          yaml.each do |page, config|
            yield page, config
          end
        end
      end # Configuration
    end # Assets
  end # Pubba
end # Sinatra
