require_relative '../../../lib/con_dux/design/link'
require 'duxml'
require 'test/unit'

class LinkTest < Test::Unit::TestCase
  include Duxml

  def setup
    @d = Element.new 'test'
  end

  attr_accessor :d

  def test_linked_by
    e = Element.new 'target'
    d << e
    d << Element.new('link')
    d.link.ref = e
    d.ref = e
    assert_equal d.object_id, e.linked_by.first.object_id
  end

  def test_split
    e = Element.new 'target'
    d << e
    d << Element.new('link')
    d.link.ref = e
    d.ref = e
    splits = e.split
    assert_equal '', splits.first
    assert_equal '', splits.second
  end

  def test_merge
    e = Dummy.new
    d[:ref] = e
  end

  def test_link_resolve
    e = Dummy.new
    d[:ref] = e
    assert_equal e.object_id, d.target.object_id
  end
end