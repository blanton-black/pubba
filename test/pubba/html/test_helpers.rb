require 'helper'
require 'sinatra/pubba/html/helpers'

class TestPubbaHTMLHelper < TestPubba
  include Sinatra::Pubba::HTML::Helpers

  def test_home_page_head_tags
    res = get('/home-page-head-tags').body
    reg = Regexp.new '<link href="http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css" rel="stylesheet" type="text/css"></link><link href="/css/home-all.css/\w+" rel="stylesheet" type="text/css"></link><link href="/css/home-phone.css/\w+" media="only screen and \(max-width: 480px\)" rel="stylesheet" type="text/css"></link><link href="/css/home-desktop.css/\w+" media="only screen and \(min-width: 480px\)" rel="stylesheet" type="text/css"></link><script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script><script src="/js/home-head.js/\w+" type="text/javascript"></script>'


    assert_match reg, res
  end

  def test_home_page_body_tags
    res = get('/home-page-body-tags').body
    reg = Regexp.new '<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js" type="text/javascript"></script><script src="/js/home-body.js/\w+" type="text/javascript"></script>'

    assert_match reg, res
  end

  def test_home_page_body_tags_with_asset_host
    Sinatra::Pubba::Site.asset_host = -> asset {"http://myasset.mydomain.com#{asset}"}
    res = get('/home-page-body-tags').body
    reg = Regexp.new '<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js" type="text/javascript"></script><script src="http://myasset.mydomain.com/js/home-body.js/\w+" type="text/javascript"></script>'

    assert_match reg, res
    Sinatra::Pubba::Site.asset_host = nil
  end
end
