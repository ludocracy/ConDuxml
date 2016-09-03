require_relative '../lib/con_duxml'
require 'test/unit'
require 'ruby-dita'

include ConDuxml

SAMPLE_FILE = File.expand_path(File.dirname(__FILE__) + '/../xml/dma.xml')
SIMPLE_TREE = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/simple_tree.xml')
SIMPLE_TREE_OUT = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/answers/simple_tree.dita')
OBJ_METH = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/object_method.xml')
OBJ_METH_OUT = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/answers/object_method.dita')
NESTED_METH = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/nested_methods.xml')
NESTED_METH_OUT = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/answers/nested_methods.dita')
GET = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/get.xml')
GET_OUT = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/answers/get.dita')
BAD_XFORM = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/bad_transform.xml')
BAD_XFORM_OUT = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/answers/bad_transform.dita')

class ConDuxmlTest < Test::Unit::TestCase
  include Dita

  def boo(arg)
    "<p>#{@source.nodes.first.text}, boo! Hi #{arg}</p>"
  end

  def setup

  end

  # TODO add tests for mismatched arities!!!

  def test_transform_simple_tree
    t = transform SIMPLE_TREE, SAMPLE_FILE
    load SIMPLE_TREE_OUT
    assert_equal doc.root[1].to_s, t.root[1].to_s

    # saving output for demo purposes
    #save SIMPLE_TREE_OUT, t
  end

  def test_transform_plugin_method
    t = transform OBJ_METH, SAMPLE_FILE
    load OBJ_METH_OUT
    assert_equal doc.root[1].to_s, t.root[1].to_s

    #save OBJ_METH_OUT, t
  end

  def test_nested_methods
    t = transform NESTED_METH, SAMPLE_FILE
    #save NESTED_METH_OUT, t
    load NESTED_METH_OUT
    assert_equal doc.root[1].to_s, t.root[1].to_s
  end

  def test_get
    t = transform GET, SAMPLE_FILE
    #save GET_OUT, t
    load GET_OUT
    assert_equal doc.root[1].to_s, t.root[1].to_s
  end

  def test_bad_xform
    assert_raise(Exception) do transform(BAD_XFORM, SAMPLE_FILE) end
    assert_nothing_raised do transform(BAD_XFORM, SAMPLE_FILE, strict: false) end
    t = transform(BAD_XFORM, SAMPLE_FILE, strict: false)
    #save BAD_XFORM_OUT, t
    assert_equal doc.root[1].to_s, t.root[1].to_s
  end

  def test_instantiate

  end
end