require 'sprockets'
require_relative 'handler'

module Sinatra
  module Pubba
    module Assets
      class SprocketsHandler < Handler
        def self.find(file)
          SprocketHandler.new(sprockets.find_asset(file))
        end

        def self.asset_paths(*paths)
          paths.each do |path|
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
      end # SprocketsHandler
    end # Assets
  end # Pubba
end # Sinatra
