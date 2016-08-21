require_relative '../lib/con_duxml'
require 'test/unit'
require_relative '../../Ruby-Dita/lib/ruby-dita'

include ConDuxml

module AddressBlock
  def boo(str)
    "base address: #{baseAddress.text}. also #{str}"
  end
end
SAMPLE_FILE = File.expand_path(File.dirname(__FILE__) + '/../xml/dma.xml')

class ConDuxmlTest < Test::Unit::TestCase
  def setup
    load SAMPLE_FILE
  end

  def test_transform_simple_tree
    t = transform File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/simple_tree.xml')

  end

  def test_transform_external_method
    omit
    t = transform File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/object_method.xml')
    assert_equal %(), t.root.to_s
  end

  def test_transform_nested_methods
    # under each method we need to test two transform types:
    #   - to_table to ensure correct content layout
    #   - split/merge of linked content to ensure correct content selection
  end

  def test_instantiate_design

  end

  def test_instantiate_transforms

  end

  def test_transform_instantiated_design

  end

  def test_inst_xform_inst_design

  end
end