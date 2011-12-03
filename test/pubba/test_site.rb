require 'helper'

class TestPubbaSite < TestPubba
  def test_global_asset_configuration_initialization
    hsh = {"styles"=>["custom/global"], "head_scripts"=>["third-party/jq"], "body_scripts"=>["third-party/jqc", "custom/app"]}
    assert_equal hsh, Sinatra::Pubba::Site.global_asset_configuration
  end

  def test_asset_handler_initialization
    assert_equal Sinatra::Pubba::Assets::SprocketsHandler, Sinatra::Pubba::Site.asset_handler
  end
end
