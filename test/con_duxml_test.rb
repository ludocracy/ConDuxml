require_relative '../lib/con_duxml'
require 'test/unit'
require 'ruby-dita'

include ConDuxml

SAMPLE_FILE = File.expand_path(File.dirname(__FILE__) + '/../xml/dma.xml')
SIMPLE_TREE = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/simple_tree.xml')
SIMPLE_TREE_OUT = File.expand_path(File.dirname(__FILE__) + '/../xml/transforms/answers/simple_tree.dita')
class ConDuxmlTest < Test::Unit::TestCase
  include Duxml
  def setup

  end

  def test_transform_simple_tree
    t = transform SIMPLE_TREE, SAMPLE_FILE
    load SIMPLE_TREE_OUT
    assert_equal doc.root[0].to_s, t.root[0].to_s
    assert_not_same doc, t

    # saving output for demo purposes
    save 'simple_tree.dita', t
  end
end