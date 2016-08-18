require_relative '../lib/con_duxml'
require 'test/unit'

class Filler
  def initialize
    @var0, @var1, @nodes = "var0's value", "var1's value", []
  end
  attr_accessor :nodes
end
SAMPLE_FILE = File.expand_path(File.dirname(__FILE__) + '/../xml/test.xml')

class ConDuxTest < Test::Unit::TestCase
  include ConDuxml
  include Duxml

  def setup
    load SAMPLE_FILE
  end

  def test_transform
    # test directives from file
    # from memory
    # embedded in source

  end

  def test_instantiate
    i = instantiate!
    #assert_equal 'table', i.topic.body.nodes[0].name
    #assert_equal 'table', i.topic.body.nodes[1].name
  end
end