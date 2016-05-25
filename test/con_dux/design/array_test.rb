require_relative '../../../lib/con_dux/directives/array'
require 'test/unit'

class Dummy
  include Tabulable
  def initialize
    @var0, @var1, @rows = "var0's value", "var1's value", []
  end
  attr_accessor :rows
end

class ArrayTest < Test::Unit::TestCase
  include Duxml
  def setup
    @d = Dummy.new
    d.rows << Dummy.new << Dummy.new
  end

  attr_reader :d

  def teardown
    # Do nothing
  end

  def test_instantiate
    h = d.to_header
    assert_equal ['var0', 'var1'], h

    h = d.to_header('var0')
    assert_equal ['var1'], h
  end

  def test_instantiate_2d

  end
end