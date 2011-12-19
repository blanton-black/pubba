require 'helper'
require 'sinatra/pubba/html/helpers'

class TestPubbaHTMLHelper < TestPubba
  include Sinatra::Pubba::HTML::Helpers

  def test_home_page_head_tags
    res = get('/home-page-head-tags').body
    puts res
    reg = Regexp.new '<link href="http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css" rel="stylesheet" type="text/css"></link><link href="/stylesheets/home-all.css/\w+" rel="stylesheet" type="text/css"></link><link href="/stylesheets/home-phone.css/\w+" media="only screen and \(max-width: 480px\)" rel="stylesheet" type="text/css"></link><link href="/stylesheets/home-desktop.css/\w+" media="only screen and \(min-width: 480px\)" rel="stylesheet" type="text/css"></link><script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script><script src="/javascripts/home-head.js/\w+" type="text/javascript"></script>'


    assert_match reg, res
  end

  def test_home_page_body_tags
    res = get('/home-page-body-tags').body
    reg = Regexp.new '<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js" type="text/javascript"></script><script src="/javascripts/home-body.js/\w+" type="text/javascript"></script>'

    assert_match reg, res
  end
end
