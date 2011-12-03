require 'helper'

class TestPubbaAssetsConfiguration < TestPubba
  def setup
    @config = Sinatra::Pubba::Assets::Configuration.new(R.pubba_config_file)
  end

  def test_yaml_is_initialized
    hsh = {"global"=>{"styles"=>["custom/global"], "head_scripts"=>["third-party/jq"], "body_scripts"=>["third-party/jqc", "custom/app"]}, "home"=>{"styles"=>["custom/home"]}, "search"=>{"styles"=>["custom/search", "third-party/widget"]}}
    assert_equal hsh, @config.yaml
  end

  def test_global_config
    hsh = {"styles"=>["custom/global"], "head_scripts"=>["third-party/jq"], "body_scripts"=>["third-party/jqc", "custom/app"]}
    assert_equal hsh, @config.global_config!

    assert_nil @config.yaml["global"]
  end

  def test_process
    sections = ["home", "search"]

    @config.global_config!

    @config.process do |page, config|
      assert sections.include?(page), "Page :#{page} not expected"
    end
  end

  def teardown
    @config = nil
  end
end
