require_relative 'page'

module Sinatra
  module Pubba
    class Site
      class << self
        attr_reader :sprockets, :asset_types
        attr_reader :script_asset_folder, :style_asset_folder
        attr_reader :script_public_folder, :style_public_folder

        def configure(app)
          @sprockets =  Sprockets::Environment.new()
          @sprockets.append_path 'app/assets/stylesheets'
          @sprockets.append_path 'app/assets/javascripts'

          @script_public_folder = File.join(app.settings.public_folder, 'javascripts')
          @style_public_folder = File.join(app.settings.public_folder, 'stylesheets')
          @script_asset_folder = File.join(app.settings.asset_folder, 'javascripts')
          @style_asset_folder = File.join(app.settings.asset_folder, 'stylesheets')
          @asset_types = {'styles' => @style_asset_folder,
                          'head_scripts' => @script_asset_folder,
                          'body_scripts' => @script_asset_folder}
        end

        def global_configuration=(hsh)
          @global_configuration = hsh
        end

        def global_configuration
          @global_configuration ||= {}
        end

        def page(name)
          pages[name]
        end

        def pages
          @pages ||= {}
        end

        def add_page(name, hash)
          page = Page.new(name, global_configuration)

          asset_types.keys.each do |asset|
            page.add_asset(asset, hash[asset]) if hash[asset]
          end

          pages[name] = page
        end

        def build(app)
          pages.each{|n, p| p.assetize }
          compile_assets(app)
        end

        private

        def compile_assets(app)
          process_assets(script_asset_folder, script_public_folder)
          process_assets(style_asset_folder, style_public_folder)
        end

        def process_assets(from_folder, to_folder)
          Dir.glob("#{from_folder}/*.*") do |file|
            asset = sprockets.find_asset(file)
            asset.write_to "#{to_folder}/#{File.basename(file)}"
          end
        end

      end #class block
    end # Site
  end # Pubba
end # Sinatra
