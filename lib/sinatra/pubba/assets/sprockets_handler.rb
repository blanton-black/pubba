require 'sprockets'
require_relative 'handler'

module Sinatra
  module Pubba
    module Assets
      class SprocketsHandler < Handler
        def self.find(file)
          SprocketsHandler.new(sprockets.find_asset(file))
        end

        def self.asset_paths(*paths)
          paths.each do |path|
            sprockets.append_path path
          end
        end

        def self.sprockets
          @sprockets ||= Sprockets::Environment.new()
        end

        def self.process(source, pattern, destination)
          Dir.glob("#{source}/#{pattern}") do |file|
            asset = find(file)
            asset.save_as "#{destination}/#{File.basename(file)}"
          end
        end

        def self.build(name, type, ext, urls)
          content = urls.collect{|url| "//= require #{url}.#{ext}"}.compact.join("\n")
          fname = File.join(Site.asset_folder, "#{name}-#{type}.#{ext}")
          File.open(fname, 'w') do |f|
            f.write Site.asset_configuration.disclaimer
            f.write content
          end
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
