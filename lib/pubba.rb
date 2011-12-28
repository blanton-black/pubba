require 'sinatra/base'
require 'rack/statica_server'

require_relative 'pubba/errors'
require_relative 'pubba/site'
require_relative 'pubba/html/helpers'

module Pubba
  class << self
    attr_accessor :config_file, :public_folder
    attr_accessor :style_folder, :script_folder
    attr_accessor :asset_folder, :asset_host
    attr_accessor :asset_handler, :asset_minifier
    attr_accessor :r18n_folder, :r18n_locale

    def configure
      yield self
      validate_settings
      Site.configure
    end

    def set_defaults
      @asset_handler  = Pubba::Assets::SprocketsHandler
      @asset_minifier = Pubba::Assets::YUIMinifier
      @script_folder  = 'js'
      @style_folder   = 'css'
    end

    def validate_settings
      missing_settings = []
      missing_settings << ":public_folder has not been set!" unless Pubba.public_folder
      missing_settings << ":asset_folder has not been set!" unless Pubba.asset_folder

      if missing_settings.length > 0
        messages = missing_settings.join("\n")
        raise Pubba::ConfigurationError.new("Missing configuration options:\n#{messages}")
      end
    end
  end
end # Pubba

Pubba.set_defaults
