require 'helper'

class TestPubbaSite < TestPubba
  def test_global_asset_configuration_initialization
    hsh = {"styles"=>["custom/global"], "head_scripts"=>["third-party/jq"], "body_scripts"=>["third-party/jqc", "custom/app"]}
    assert_equal hsh, Sinatra::Pubba::Site.global_asset_configuration
  end

  def test_asset_handler_initialization
    assert_equal Sinatra::Pubba::Assets::SprocketsHandler, Sinatra::Pubba::Site.asset_handler
  end

  def test_script_public_folder_initialization
    assert_equal "#{R.public_dir}/javascripts", Sinatra::Pubba::Site.script_public_folder
  end

  def test_style_public_folder_initialization
    assert_equal "#{R.public_dir}/stylesheets", Sinatra::Pubba::Site.style_public_folder
  end

  def test_script_asset_folder_initialization
    assert_equal "#{R.asset_dir}/javascripts", Sinatra::Pubba::Site.script_asset_folder
  end

  def test_style_asset_folder_initialization
    assert_equal "#{R.asset_dir}/stylesheets", Sinatra::Pubba::Site.style_asset_folder
  end

  def test_asset_types_initialization
    asset_types = Sinatra::Pubba::Site.asset_types
    assert_equal Sinatra::Pubba::Site.style_asset_folder, asset_types.delete('styles')
    assert_equal Sinatra::Pubba::Site.script_asset_folder, asset_types.delete('head_scripts')
    assert_equal Sinatra::Pubba::Site.script_asset_folder, asset_types.delete('body_scripts')
    assert asset_types.empty?
  end
end
