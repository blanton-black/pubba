require 'helper'

class TestPubbaAssetsConfiguration < TestPubba
  def setup
    @config = Sinatra::Pubba::Assets::Configuration.new(R.pubba_config_file)
  end

  def test_yaml_is_initialized
    hsh = {"global"=>{"styles"=>{"all"=>{"urls"=>["http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css", "custom/global"]}, "phone"=>{"media"=>"only screen and (max-width: 480px)", "urls"=>["custom/small"]}, "desktop"=>{"media"=>"only screen and (min-width: 480px)", "urls"=>["custom/large"]}}, "scripts"=>{"head"=>["https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js", "third-party/modernizr"], "body"=>["https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js", "third-party/backbone", "custom/app", "custom/tracker"]}}, "home"=>{"styles"=>{"all"=>{"urls"=>["custom/home"]}}}, "search"=>{"styles"=>{"all"=>{"urls"=>["custom/search", "third-party/widget"]}}, "scripts"=>{"body"=>["custom/lightbox"]}}}

    assert_equal hsh, @config.yaml
  end

  def test_global_config
    hsh = {"styles"=>{"all"=>{"urls"=>["http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css", "custom/global"]}, "phone"=>{"media"=>"only screen and (max-width: 480px)", "urls"=>["custom/small"]}, "desktop"=>{"media"=>"only screen and (min-width: 480px)", "urls"=>["custom/large"]}}, "scripts"=>{"head"=>["https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js", "third-party/modernizr"], "body"=>["https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js", "third-party/backbone", "custom/app", "custom/tracker"]}}

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
