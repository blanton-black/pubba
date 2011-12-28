require 'statica'

require_relative 'assets/configuration'
require_relative 'assets/sprockets_handler'
require_relative 'assets/yui_minifier'
require_relative 'page'

module Pubba
  module Site
    extend self

    attr_reader :asset_configuration, :locale

    def configure
      Statica.root_dir  = Pubba.public_folder

      maybe_init_r18n

      # Load pubba_config
      @asset_configuration = Pubba::Assets::Configuration.new(Pubba.config_file)

      # Set assset handler
      configure_asset_handler

      # Set pages to empty hash
      @pages = {}

      # Process the remaining @pubba_config sections
      asset_configuration.process do |p, config|
        add_page(p, config)
      end
    end

    def process
      pages.each{|name, p| p.assetize }

      asset_script_folder = File.join(Pubba.asset_folder, 'out', Pubba.script_folder)
      asset_style_folder = File.join(Pubba.asset_folder, 'out', Pubba.style_folder)

      public_script_folder = File.join(Pubba.public_folder, Pubba.script_folder)
      public_style_folder = File.join(Pubba.public_folder, Pubba.style_folder)

      Pubba.asset_handler.process(asset_script_folder, public_script_folder)
      Pubba.asset_handler.process(asset_style_folder, public_style_folder)

      Pubba.asset_minifier.minify(public_script_folder, :js)
      Pubba.asset_minifier.minify(public_style_folder, :css)
    end

    def asset_host=(p)
      @asset_host = p
    end

    def asset_host
      @asset_host ||= -> asset {asset}
    end

    def maybe_init_r18n
      return unless Pubba.r18n_folder

      locale = 'en'
      locale = Pubba.r18n_locale if Pubba.r18n_locale

      @r18n_folder  =  Pubba.r18n_folder
      @r18n_locale   = locale

      require_relative 'locale'

      @locale = Locale.new
    end

    def configure_asset_handler
      Pubba.asset_handler.asset_paths  Pubba.asset_folder,
                                  File.join(Pubba.asset_folder, Pubba.style_folder),
                                  File.join(Pubba.asset_folder, Pubba.script_folder)
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
