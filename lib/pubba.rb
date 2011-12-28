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
    end

    def set_defaults
      @asset_handler  = Pubba::Assets::SprocketsHandler
      @asset_minifier = Pubba::Assets::YUIMinifier
      @script_folder  = 'js'
      @style_folder   = 'css'
    end
  end
end # Pubba

Pubba.set_defaults
