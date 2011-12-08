require 'psych'

module Sinatra
  module Pubba
    module Assets
      class Configuration
        attr_reader :yaml
        attr_reader :name

        def initialize(config_file)
          @name = File.basename(config_file)
          @yaml = Psych.load_file(config_file)
        end

        def global_config!
          @global_config ||= (yaml.delete("global") || {})
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
