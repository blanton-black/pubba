require 'helper'
require 'sinatra/pubba/html/helpers'

class TestPubbaHTMLHelper < TestPubba
  include Sinatra::Pubba::HTML::Helpers

  def test_home_page_head_tags
    res = get('/home-page-head-tags').body.gsub /\d/,'1'
    str = %|<link href="/stylesheets/home-styles.css?aid=111111111" rel="stylesheet" type="text/css"></link><script src="/javascripts/home-head.js?aid=111111111" type="text/javascript"></script>|
    assert_equal str, res
  end

  def test_home_page_body_tags
    res = get('/home-page-body-tags').body.gsub /\d/,'1'
    str = %|<script src="/javascripts/home-body.js?aid=111111111" type="text/javascript"></script>|
    assert_equal str, res
  end
end
