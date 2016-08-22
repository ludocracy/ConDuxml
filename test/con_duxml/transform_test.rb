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

  def test_get_sources
    sources = get_sources(xform)
    assert_equal 1, sources.size
    source_str = sources.collect do |source| source.sclone.to_s end.join
    assert_equal '<ipxact:memoryMap/>', source_str
  end

  def test_get_method
    m = get_method(xform)
    assert_equal '#<Method: Dita.topic>', m.to_s
  end

  def test_get_args
    args = get_args(xform, get_sources(xform).first)
    assert_equal 'ambaAPB', args.first
  end

  def test_activate
    t = activate(xform, source)
    assert_match /<topic id="topic[0-9]{8}"><title>ambaAPB<\/title><\/topic>/, t.first.to_s
  end

  def test_object_method

  end
end