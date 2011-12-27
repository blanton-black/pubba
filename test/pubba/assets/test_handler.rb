require 'helper'

class TestHandler < TestPubba
  def test_asset
    assert_raises NotImplementedError do
      Pubba::Assets::Handler.asset('')
    end
  end

  def test_save_as
    handler = Pubba::Assets::Handler.new
    assert_raises NotImplementedError do
      handler.save_as('')
    end
  end

  def test_process
    handler = Pubba::Assets::Handler.new
    assert_raises NotImplementedError do
      handler.process('', '')
    end
  end

  def test_build
    handler = Pubba::Assets::Handler.new
    assert_raises NotImplementedError do
      handler.build('', '', '', '')
    end
  end
end
