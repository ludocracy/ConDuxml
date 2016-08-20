require_relative '../../lib/con_duxml/transform'
require 'test/unit'
require_relative '../../lib/con_duxml/duxml_ext/element'


module Ipxact
  module MemoryMap
    def pop
      Duxml::Element.new('pop', ['!!!'])
    end
  end
end

class TransformTest < Test::Unit::TestCase
  include Duxml

  XFORM_PATH = '../../xml/transforms/from_root.xml'

  def setup
    load '../../xml/dma.xml'
    @t = Element.new('transform', {ns: 'ipxact'})
  end

  attr_accessor :t

  def teardown
    # Do nothing
  end

  def test_activate_method_no_target
    t[:method] = 'sclone'
    result = t.activate(doc)
    assert_equal 'ipxact:component', result[0].name
    assert_equal 'http://www.w3.org/2001/XMLSchema-instance', result[0]['xmlns:xsi']
  end

  def test_activate_method_on_target
    t[:method] = 'sclone'
    t[:target] = 'component/memoryMaps/memoryMap'
    result = t.activate(doc)
    assert_equal '<ipxact:memoryMap/>', result[0].to_s
  end

  def test_activate_external_method
    t[:method] = 'pop'
    t[:target] = 'component/memoryMaps/memoryMap'
    result = t.activate(doc)
    assert_equal '<pop>!!!</pop>', result[0].to_s
  end
end