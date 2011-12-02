require 'helper'

class TestHandler < TestPubba
  def test_asset
    assert_raises NotImplementedError do
      Sinatra::Pubba::Assets::Handler.asset('')
    end
  end

  def test_save_as
    handler = Sinatra::Pubba::Assets::Handler.new
    assert_raises NotImplementedError do
      handler.save_as('')
    end
  end
end
