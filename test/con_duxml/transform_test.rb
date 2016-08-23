require_relative '../../lib/con_duxml/transform'
require 'test/unit'
require_relative '../../lib/con_duxml/duxml_ext/element'
require 'ruby-dita'

class TransformTest < Test::Unit::TestCase
  include Transform
  include Duxml

  def setup
    load '../../xml/dma.xml'
    @src_ns = 'ipxact'
    @xform = Element.new('dita:topic', {source: 'component/memoryMaps/memoryMap', arg0: 'name/*'})
    @source = doc
  end

  attr_reader :topic, :src_ns, :xform

  def teardown
    # Do nothing
  end

  def test_
    # TODO test public methods here!
  end
end