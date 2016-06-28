require_relative '../../lib/con_dux/mappable'
require_relative '../../lib/duxml_ext/element'
require 'test/unit'

include ConDuxml
class MappableTest < Test::Unit::TestCase
  include Mappable

  def test_dita_map
    t = dita_map 'title'
    assert_equal 'title', t.title.text
  end
end