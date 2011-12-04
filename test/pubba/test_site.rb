require 'helper'

class TestPubbaSite < TestPubba
  def test_asset_handler_initialization
    assert_equal Sinatra::Pubba::Assets::SprocketsHandler, Sinatra::Pubba::Site.asset_handler
  end

  def test_script_public_folder_initialization
    assert_equal "#{R.public_folder}/javascripts", Sinatra::Pubba::Site.script_public_folder
  end

  def test_style_public_folder_initialization
    assert_equal "#{R.public_folder}/stylesheets", Sinatra::Pubba::Site.style_public_folder
  end

  def test_script_asset_folder_initialization
    assert_equal "#{R.asset_folder}/javascripts", Sinatra::Pubba::Site.script_asset_folder
  end

  def test_style_asset_folder_initialization
    assert_equal "#{R.asset_folder}/stylesheets", Sinatra::Pubba::Site.style_asset_folder
  end
end
