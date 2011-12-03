require 'minitest/unit'
require 'sinatra/test_helpers'

MiniTest::Unit.autorun

module R
  extend self

  def asset_dir
    File.join(File.dirname(__FILE__), 'sinatra', 'app', 'assets')
  end

  def public_dir
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

      settings.set :public_folder, R.public_dir
      settings.set :asset_folder, R.asset_dir

      settings.set :pubba_config, R.pubba_config_file

      register Sinatra::Pubba
    end
  end

  def teardown
    [R.asset_dir, R.public_dir].each do |root_dir|
      Dir.glob(File.join(root_dir, 'javascripts', '*.js')) do |f|
        File.delete(f) if File.exist?(f)
      end

      Dir.glob(File.join(root_dir, 'stylesheets', '*.css')) do |f|
        File.delete(f) if File.exist?(f)
      end
    end
  end

  def empty_hash
    {}
  end
end

