require_relative '../../../lib/con_duxml/transform/transform_private'
require 'test/unit'
require_relative '../../../lib/con_duxml/duxml_ext/element'
require 'ruby-dita'

class TransformPrivateTest < Test::Unit::TestCase
  include Private
  include Duxml

  def setup
    load '../../../xml/dma.xml'
    @src_ns = 'ipxact'
    @every_arg = Element.new('dita:topic', {source: 'component/memoryMaps/memoryMap',
                                        arg0: 'name/*',
                                        arg1: "'a string key' => 8",
                                        arg2: "symbol: 'a string val'",
                                        arg3: 'symbol: name/*',
                                        arg4: "'a', 'b', 'c'",
                                        arg5: 'a: 0, b: 1, c: 3',
                                        arg6: 'name/*, name/*'})
    @xform = Element.new('dita:topic', {source: 'component/memoryMaps/memoryMap', arg0: 'name/*'})
    @source = doc
  end

  attr_reader :source, :src_ns, :xform, :every_arg

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
    assert_equal '#<Method: TransformPrivateTest(Dita)#topic>', m.to_s
  end

  def test_get_args
    target = get_sources(every_arg).first
    args = get_args(every_arg, target)
    assert_equal 'ambaAPB', args.first
    ans1 = {'a string key' => '8'}
    ans2 = {symbol: 'a string val'}
    ans3 = {symbol: 'ambaAPB'}
    ans4 = %w(a b c)
    ans5 = {a: '0', b: '1', c: '3'}
    ans6 = %w(ambaAPB ambaAPB)
    assert_equal ans1, args[1]
    assert_equal ans2, args[2]
    assert_equal ans3, args[3]
    assert_equal ans4, args[4]
    assert_equal ans5, args[5]
    assert_equal ans6, args[6]
  end

  def test_activate
    t = activate(xform, source)
    assert_match /<topic id="topic[0-9]{8}"><title>ambaAPB<\/title><\/topic>/, t.first.to_s
  end

  def test_object_method

  end
end