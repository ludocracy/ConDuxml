require_relative '../../lib/con_dux/mappable'
require_relative '../../lib/duxml_ext/element'
require 'test/unit'

include ConDuxml

module Test
  # TODO define mapping output behavior
end

class MappableTest < Test::Unit::TestCase
  def setup
    @d = Element.new('test')
    @d.extend Mappable
  end
  attr_reader :d

  def test_1_level
    map = d.dita_map
    assert_equal '', map.root.to_s
  end

  def test_2_levels
    d.nodes << Element.new('test')
    d.nodes.first << Element.new('test')
    d.test.test.extend Mappable
    map = d.dita_map
    assert_equal '', map.root.to_s
  end

  def test_3_levels
    d.nodes << Element.new('filler')
    d.nodes.first << Element.new('test')
    d.nodes.first.nodes.first.extend Mappable
    d.nodes.first.nodes.first << Element.new('filler')
    map = d.dita_map
    assert_equal '', map.root.to_s
  end

  def test_composite

  end

  def test_topicize
#    r = d.to_dita
#    File.write 'test.dita', r
    #assert_equal answer[0].to_s, r.to_s
  end
end