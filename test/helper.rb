require 'minitest/unit'
require 'sinatra/test_helpers'

MiniTest::Unit.autorun

class TestPubba < MiniTest::Unit::TestCase
  include Sinatra::TestHelpers

  def setup
    mock_app do
      require 'sinatra/pubba'

      settings.set :public_folder, File.join(File.dirname(__FILE__), 'sinatra', 'public')
      settings.set :asset_folder, File.join(File.dirname(__FILE__), 'sinatra', 'app', 'assets')

      settings.set :pubba_config, File.join(File.dirname(__FILE__), 'sinatra', 'config', 'pubba.yml')

      register Sinatra::Pubba
    end
  end

  def empty_hash
    {}
  end
end
