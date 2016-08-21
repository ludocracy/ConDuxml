require_relative '../../lib/con_duxml/transform'
require 'test/unit'
require_relative '../../lib/con_duxml/duxml_ext/element'
require 'ruby-dita'

module Ipxact
  module MemoryMap
    def pop
      Duxml::Element.new('pop', ['!!!'])
    end
  end
end

class TransformTest < Test::Unit::TestCase
  include Transform
  include Duxml

  def setup
    load '../../xml/dma.xml'
    @src_ns = 'ipxact'
    topic = Element.new('dita:topic', {source: 'component/memoryMaps/memoryMap', arg0: 'name/*'})
    @xform = topic
    @source = doc
  end

  attr_reader :topic, :src_ns, :xform

  def teardown
    # Do nothing
  end

  def test_get_sources
    sources = get_sources
    assert_equal 1, sources.size
    source_str = sources.collect do |source| source.sclone.to_s end.join
    assert_equal '<ipxact:memoryMap/>', source_str
  end

  def test_get_method
    m = get_method
    assert_equal '#<Method: Dita.topic>', m.to_s
  end

  def test_get_args
    args = get_args(get_sources.first)
    assert_equal 'ambaAPB', args.first
  end

  def test_activate
    t = activate(xform, doc)
    assert_match /<topic id="topic[0-9]{8}"><title>ambaAPB<\/title><\/topic>/, t.first.to_s
  end
end