require 'test/unit'
require_relative  '../../../lib/con_duxml/duxml_ext/element'

include Duxml

class ElementTest < Test::Unit::TestCase
  def setup

    @e = Element.new('test')
    3.times do @e << Element.new('child') end
    e.nodes[0][:attr] = 'duck'
    e.nodes[1][:attr] = 'duck'
    e.nodes[2][:attr] = 'goose'
  end

  attr_reader :e

  def test_split
    ans = e.split do |child| child[:attr] end
    assert_equal '<test><child attr="duck"/><child attr="duck"/></test>', ans.first.to_s
    assert_equal '<test><child attr="goose"/></test>', ans.last.to_s
  end

  def test_merge
    e.nodes[0][:conflict] = 'resolved'
    e.nodes[1][:conflict] = 'unresolved'
    ans = e.merge do |n| n[:attr] end
    assert_equal 3, ans.nodes.size
    assert_equal '<child attr="duck" conflict="resolved"/>', ans.nodes[0].to_s
    assert_equal '<child attr="duck" conflict="unresolved"/>', ans.nodes[1].to_s
    assert_equal '<child attr="goose"/>', ans.nodes[2].to_s
  end

  def test_merge_conflict
    e.nodes[0][:conflict] = 'resolved'
    e.nodes[1][:conflict] = 'unresolved'
    ans = e.merge(:conflict) do |n| n[:attr] end
    assert_equal 2, ans.nodes.size
    assert_equal '<child attr="duck" conflict="resolved"/>', ans.nodes[0].to_s
    assert_equal '<child attr="goose"/>', ans.nodes[1].to_s
  end


  def test_merge_conflict_overwrite
    e.nodes[0][:conflict] = 'resolved'
    e.nodes[1][:conflict] = 'unresolved'
    ans1 = e.merge(conflict: 'left field') do |n| n[:attr] end
    assert_equal 2, ans1.nodes.size
    assert_equal '<child attr="duck" conflict="left field"/>', ans1.nodes[0].to_s
    assert_equal '<child attr="goose"/>', ans1.nodes[1].to_s
  end
end
