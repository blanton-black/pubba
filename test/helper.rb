require 'minitest/unit'
require 'sinatra/test_helpers'

MiniTest::Unit.autorun

module R
  extend self

  def app_folder
    File.join(File.dirname(__FILE__), 'sinatra', 'app')
  end

  def asset_folder
    File.join(app_folder, 'assets')
  end

  def r18n_folder
    File.join(app_folder, 'i18n')
  end

  def public_folder
    File.join(File.dirname(__FILE__), 'sinatra', 'public')
  end

  def pubba_config_file
    File.join(File.dirname(__FILE__), 'sinatra', 'config', 'pubba.yml')
  end
end

class TestPubba < MiniTest::Unit::TestCase
  include Sinatra::TestHelpers

  def setup
    mock_app do
      require 'sinatra/pubba'

      settings.set :public_folder, R.public_folder
      settings.set :asset_folder, R.asset_folder
      settings.set :r18n_folder, R.r18n_folder

      settings.set :pubba_config, R.pubba_config_file

      register Sinatra::Pubba

      get('/home-page-head-tags') do
        @page = Sinatra::Pubba::Site.page('home');
        page_head_tags
      end

      get('/home-page-body-tags') do
        @page = Sinatra::Pubba::Site.page('home');
        page_body_tags
      end
    end
  end

  def teardown
    [R.asset_folder, R.public_folder].each do |root_folder|
      Dir.glob(File.join(root_folder, 'javascripts', '*.js')) do |f|
        File.delete(f) if File.exist?(f)
      end

      Dir.glob(File.join(root_folder, 'stylesheets', '*.css')) do |f|
        File.delete(f) if File.exist?(f)
      end
    end
  end

  def empty_hash
    {}
  end
end

