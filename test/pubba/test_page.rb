require 'helper'

class TestPubbaPage < TestPubba
  def test_home_r18n
    page = Sinatra::Pubba::Site.page('home')

    assert_equal 'Home title', page.title
    assert_equal 'Logout', page.logout_link
  end

  def test_search_r18n
    page = Sinatra::Pubba::Site.page('search')

    assert_equal 'Search title', page.title
    assert_equal 'Logout', page.logout_link
  end
end
