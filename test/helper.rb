require 'minitest/unit'
require 'sinatra/test_helpers'

MiniTest::Unit.autorun

class TestPubba < MiniTest::Unit::TestCase
  include Sinatra::TestHelpers

  def setup
    mock_app do
      require 'sinatra/pubba'
    end
  end
end
