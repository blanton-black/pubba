require 'sprockets'

module Sinatra
  module Pubba
    class SprocketHandler < AssetHandler
      def self.find(file)
        SprocketHandler.new(sprockets.find_asset(file))
      end

      def self.asset_paths(*paths)
        paths.each do
          sprockets.append_path path
        end
      end

      def self.sprockets
        @sprockets ||= Sprockets::Environment.new()
      end

      attr_reader :asset

      def initialize(asset)
        @asset = asset
      end

      def save_as(file)
        asset.write_to(file)
      end
    end
  end
end