require_relative '../../lib/con_dux/mappable'
require 'test/unit'


class Filler
  def initialize
    @var0, @var1, @nodes = "var0's value", "var1's value", []
  end
  attr_accessor :nodes
end

class Dummy < Filler
  include Mappable
end

class MappableTest < Test::Unit::TestCase
  def test_1_level
    first = Dummy.new
    first.nodes << Dummy.new
    map = first.dita_map
    assert_equal '', map.root.to_s
  end

  def test_2_levels

    first = Dummy.new
    first.nodes << Dummy.new
    first.nodes.first << Dummy.new
    map = first.dita_map
    assert_equal '', map.root.to_s
  end

  def test_3_levels
    # all mappable
    first = Dummy.new
    first.nodes << Filler.new
    first.nodes.first << Dummy.new
    first.nodes.first.nodes.first << Filler.new
    map = first.dita_map
    assert_equal '', map.root.to_s
  end

  def test_composite

  end

  def test_topicize
    r = d.to_dita
    File.write 'test.dita', r
    #assert_equal answer[0].to_s, r.to_s
  end
end