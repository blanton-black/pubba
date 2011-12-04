module Sinatra
  module Pubba
    class Page
      attr_accessor :name
      attr_reader :assets

      def initialize(name, global_configuration = {})
        @name = name
        @assets = {}

        ["styles", "scripts"].each do |asset|
          @assets[asset] = {}
          global_configuration[asset].each do |key, value|
            @assets[asset][key] = value
          end
        end
      end

      def add_asset(name, section)
        if name == "styles"
           section.each do |section_name, hsh|
             hsh.each do |key, value|
              if key == "urls"
                @assets[name][section_name][key] += value
              else
                @assets[name][section_name][key] = value
              end
            end
          end
        else
          @assets["scripts"]["head"] += section["head"] if section["head"]
          @assets["scripts"]["body"] += section["body"] if section["body"]
        end
      end

      def assetize
        create_asset('styles', Site.style_asset_folder)
        create_asset('scripts', Site.script_asset_folder)
      end

      def method_missing(meth, *args)
        if Site.locale && (t = Site.locale.get(name, meth, *args))
          return t
        end
        super
      end

      private

      def process_scripts(array)
        return [] if array.nil? || array.empty?

        array.each{|ele| scripts << ele }
      end

      def create_asset(asset, dir)
        type = asset.split('_').first
        ext  = asset.end_with?('styles') ? 'css' : 'js'

        File.open( File.join(dir, "#{name}-#{type}.#{ext}"), 'w') do |f|
          f.write Site.disclaimer
          assets[asset].each do |script|
            f.write "//= require #{script}.#{ext}\n"
          end
        end
      end
    end # Page
  end # Pubba
end # Sinatra
