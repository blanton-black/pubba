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
            @assets[asset][key] = value.dup
          end
        end
      end

      def add_asset(type, section)
        if type == "styles"
           section.each do |section_name, hsh|
             hsh.each do |key, value|
              if key == "urls"
                @assets[type][section_name][key] += value
              else
                @assets[type][section_name][key] = value
              end
            end
          end
        else
          @assets["scripts"]["head"] += section["head"] if section["head"]
          @assets["scripts"]["body"] += section["body"] if section["body"]
        end
      end

      def assetize
        create_style_assets
        create_script_assets
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

      def create_style_assets
        @assets["styles"].each do |part, hsh|
          content = []
          @assets["styles"][part]["urls"].each do |url|
            next if url.start_with?("http")
            content << "//= require #{url}.css"
          end
          write_asset(Site.style_asset_folder, part, "css", content.compact.join("\n"))
        end
      end

      def create_script_assets
        ["head", "body"].each do |part|
          content = []
          @assets["scripts"][part].each do |url|
            next if url.start_with?("http")
            content << "//= require #{url}.js"
          end
          write_asset(Site.script_asset_folder, part, "js", content.compact.join("\n"))
        end
      end

      def write_asset(dir, type, ext, content)
        fname = File.join(dir, "#{name}-#{type}.#{ext}")
        File.open(fname, 'w') do |f|
          f.write Site.disclaimer
          f.write content
        end
      end
    end # Page
  end # Pubba
end # Sinatra
