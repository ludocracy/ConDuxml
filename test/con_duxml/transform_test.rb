require_relative '../../lib/con_duxml/transform'
require 'test/unit'
require 'duxml'
include ConDuxml

class TransformTest < Test::Unit::TestCase
  include Duxml

  XFORM_PATH = '../../xml/transforms/from_root.xml'

  module IPXACT
    module MemoryMap
      def pop
        Element.new('pop', '!!!')
      end
    end
  end

  def setup
    load '../../xml/dma.xml'
    @t = Element.new('transform')
    @t[:ns] = 'ipxact'
  end

  attr_accessor :t

  def teardown
    # Do nothing
  end

  def test_activate_method_no_target
    t[:method] = 'sclone'
    result = t.activate(doc)
    assert_equal 'ipxact:component', result.name
    assert_equal 'http://www.w3.org/2001/XMLSchema-instance', result['xmlns:xsi']
  end

  def test_activate_method_on_target
    t[:method] = 'sclone'
    t[:target] = 'component memoryMaps memoryMap'
    result = t.activate(doc)
    assert_equal '<ipxact:memoryMap/>', result.to_s
  end

  def test_activate_external_method
    t[:method] = 'pop'
    t[:target] = 'component memoryMaps memoryMap'
    result = t.activate(doc)
    assert_equal '<pop>!!!</pop>', result.to_s
  end
end