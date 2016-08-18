require_relative '../../../lib/con_duxml/design/link'
require 'test/unit'

include ConDuxml
include Duxml

class Observer
  def update(type, data)

  end
end

class LinkTest < Test::Unit::TestCase

  def setup
    @d = Element.new('test')
    @d << Element.new('link')
  end

  attr_accessor :d

  def test_instantiate
    # test
    e = Element.new 'target'
    d.link.ref = e
    r = d.link.instantiate
    assert_same
  end

  def test_ref=
    e = Element.new 'target'
    d.link.ref = e
    assert_equal d.object_id, e.linked_by.first.object_id
  end

  def test_linked_by

  end

  def test_split
    e = Element.new 'target'
    d << Element.new('link')
    d.link.ref = e
    splits = e.split
    assert_equal '', splits.first
    assert_equal '', splits.second
  end

  def test_merge
    root = Element.new('root', %(<target0/><target1/>))
    d << Element.new('link')
    d.link[:ref] = root[0]
    m = e.merge() do |group| group.first end
    assert_same d.link.ref, m, "link's referent should be same as result of merging original target and its sibling(s)"
  end

  def test_update

  end
end