require_relative '../../lib/con_duxml/instance'
require 'test/unit'
require 'duxml'
include ConDuxml
include Duxml

class InstanceTest < Test::Unit::TestCase
  def setup
    @d = Element.new('test')
  end

  attr_reader :d

  def teardown
    # Do nothing
  end

  def test_instantiate
    e = Element.new('target')
    d.extend Instance
    d.ref = e
    assert_equal [e].to_s, d.instantiate.to_s
    assert_not_equal e.object_id, d.instantiate.object_id
  end
end