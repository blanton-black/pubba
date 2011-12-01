module Sinatra
  module Pubba
    class AssetConfiguration
      attr_reader :yaml

      def initialize(config_file)
        @yaml = Psych.load_file(config_file)
      end

      def process
        yaml.each do |page, config|
          yield page, config
        end
      end
    end
  end
end
