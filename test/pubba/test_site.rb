require 'helper'

class TestPubbaSite < TestPubba
  def test_asset_handler_initialization
    assert_equal Sinatra::Pubba::Assets::SprocketsHandler, Sinatra::Pubba::Site.asset_handler
  end

  def test_asset_handler_initialization
    assert_equal Sinatra::Pubba::Assets::YUIMinifier, Sinatra::Pubba::Site.asset_minifier
  end

  def test_asset_folder_initialization
    assert_equal "#{R.asset_folder}", Sinatra::Pubba::Site.asset_folder
  end

  def test_public_folder_initialization
    assert_equal "#{R.public_folder}", Sinatra::Pubba::Site.public_folder
  end

  def test_script_folder_initialization
    assert_equal "js", Sinatra::Pubba::Site.script_folder
  end

  def test_style_folder_initialization
    assert_equal "css", Sinatra::Pubba::Site.style_folder
  end
end
