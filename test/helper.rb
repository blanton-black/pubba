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
      require 'pubba'

      settings.set :public_folder, R.public_folder

      Pubba.configure do |p|
        p.config_file   = R.pubba_config_file
        p.public_folder = settings.public_folder
        p.asset_folder  = R.asset_folder
        p.r18n_folder   = R.r18n_folder
      end

      Pubba::Site.configure

      helpers Pubba::HTML::Helpers

      get('/') do
        'OK'
      end

      get('/home-page-head-tags') do
        @page = Pubba::Site.page('home');
        page_head_tags
      end

      get('/home-page-body-tags') do
        @page = Pubba::Site.page('home');
        page_body_tags
      end
    end

    get '/'
  end

  def empty_hash
    {}
  end
end

