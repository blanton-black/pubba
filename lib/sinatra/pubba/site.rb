require 'statica'

require_relative 'assets/configuration'
require_relative 'assets/sprockets_handler'
require_relative 'assets/yui_minifier'
require_relative 'page'

module Sinatra
  module Pubba
    module Site
      extend self
      attr_reader :public_folder, :asset_folder, :script_folder, :style_folder
      attr_reader :asset_configuration, :asset_handler, :asset_minifier
      attr_reader :locale, :r18n_folder, :r18n_locale

      def configure(app)
        return if @configured

        puts "Configuring Pubba..."

        settings = app.settings

        validate_settings(settings)

        set_folder_defaults(settings)

        maybe_init_r18n(settings)

        # Load pubba_config
        @asset_configuration = Sinatra::Pubba::Assets::Configuration.new(settings.pubba_config)

        # Set assset handler
        configure_asset_handler(settings)

        # Set compressor
        configure_asset_compressor(settings)

        # Process the remaining @pubba_config sections
        asset_configuration.process do |p, config|
          add_page(p, config)
        end

        if app.settings.development? || app.settings.test?
          process

          require_relative 'monitor'
          Monitor.do
        end

        @configured = true
      end

      def process
        pages.each{|name, p| p.assetize }

        asset_script_folder = File.join(asset_folder, 'out', script_folder)
        asset_style_folder = File.join(asset_folder, 'out', style_folder)

        public_script_folder = File.join(public_folder, script_folder)
        public_style_folder = File.join(public_folder, style_folder)

        asset_handler.process(asset_script_folder, public_script_folder)
        asset_handler.process(asset_style_folder, public_style_folder)

        asset_minifier.minify(public_script_folder, :js)
        asset_minifier.minify(public_style_folder, :css)
      end

      def validate_settings(settings)
        missing_settings = []
        unless settings.respond_to? :public_folder
          missing_settings << ":public_folder has not been set!"
        end

        unless settings.respond_to? :asset_folder
          missing_settings << ":asset_folder has not been set!"
        end

        if missing_settings.length > 0
          messages = missing_settings.join("\n")
          raise Pubba::ConfigurationError.new("Missing configuration options:\n#{messages}")
        end
      end

      def set_folder_defaults(settings)
        @public_folder    = settings.public_folder
        @asset_folder     = settings.asset_folder
        @script_folder    = 'js'
        @style_folder     = 'css'

        Statica.root_dir  = settings.public_folder
      end

      def maybe_init_r18n(settings)
        return unless settings.respond_to?(:r18n_folder)

        locale = 'en'
        if settings.respond_to?(:r18n_locale)
          locale = settings.r18n_locale
        end

        @r18n_folder  =  settings.r18n_folder
        @r18n_locale   = locale

        require_relative 'locale'

        @locale = Locale.new
      end

      def configure_asset_handler(settings)
        @asset_handler = Sinatra::Pubba::Assets::SprocketsHandler
        if settings.respond_to?(:asset_handler) && (handler = settings.asset_handler)
          @asset_handler = handler
        end
        @asset_handler.asset_paths  asset_folder,
                                    File.join(asset_folder, style_folder),
                                    File.join(asset_folder, script_folder)
      end

      def configure_asset_compressor(settings)
        @asset_minifier = Sinatra::Pubba::Assets::YUIMinifier
        if settings.respond_to?(:asset_minifier) && (minifier = settings.asset_minifier)
          @asset_minifier = minifier
        end
      end

      def page(name)
        pages[name]
      end

      def pages
        @pages ||= {}
      end

      def add_page(name, hsh)
        p = Page.new(name, @asset_configuration.global_config!)

        p.add_asset('styles', hsh['styles']) if hsh['styles']
        p.add_asset('scripts', hsh['scripts']) if hsh['scripts']

        p.tagify

        pages[name] = p
      end
    end # Site
  end # Pubba
end # Sinatra
