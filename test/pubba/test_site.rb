require 'helper'

class TestPubbaSite < TestPubba
  def test_asset_handler_initialization
    assert_equal Pubba::Assets::SprocketsHandler, Pubba.asset_handler
  end

  def test_asset_handler_initialization
    assert_equal Pubba::Assets::YUIMinifier, Pubba.asset_minifier
  end

  def test_asset_folder_initialization
    assert_equal "#{R.asset_folder}", Pubba.asset_folder
  end

  def test_public_folder_initialization
    assert_equal "#{R.public_folder}", Pubba.public_folder
  end

  def test_script_folder_initialization
    assert_equal "js", Pubba.script_folder
  end

  def test_style_folder_initialization
    assert_equal "css", Pubba.style_folder
  end
end
