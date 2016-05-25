require_relative '../lib/con_dux'
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

  def setup
    load SAMPLE_FILE
  end

  def test_instantiate
    i = instantiate
    assert_equal '', i.root.to_s
  end
end