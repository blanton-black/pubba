require 'helper'

class TestMinifier < TestPubba
  def test_minify
    assert_raises NotImplementedError do
      Pubba::Assets::Minifier.minify("/folder/path", :js)
    end
  end
end
