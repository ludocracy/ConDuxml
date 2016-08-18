require_relative '../../../lib/con_duxml/design/array'
require 'test/unit'

class ArrayTest < Test::Unit::TestCase
  def setup
    @d = Duxml::Element.new('con_duxml:array')
    d << Duxml::Element.new('child')
  end

  attr_accessor :d

  def teardown
    # Do nothing
  end

  def test_instantiate
    d[:size] = 4
    a = d.instantiate
    a0 = a.collect do |child| child.to_s end
    assert_equal %w(<child/> <child/> <child/> <child/>), a0

    b = d.instantiate do |node, i| node.value = "#{node.name+i.to_s}"; node end
    b0 = b.collect do |child| child.to_s end
    assert_equal %w(<child0/> <child1/> <child2/> <child3/>), b0
  end

  def test_instantiate_2d

  end
end