require_relative '../../lib/con_dux/tabulable'
require 'test/unit'

class Dummy
  include Tabulable
  def initialize
    @var0, @var1, @rows = "var0's value", "var1's value", []
  end
  attr_accessor :rows
end

class TabulableTest < Test::Unit::TestCase
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @d = Dummy.new
    d.rows << Dummy.new << Dummy.new
  end

  attr_reader :d

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_to_header
    h = d.to_header
    assert_equal ['var0', 'var1'], h

    h = d.to_header('var0')
    assert_equal ['var1'], h
  end

  def test_to_row
    r = d.to_row('rows')
    assert_equal ["var0's value", "var1's value"], r
  end

  def test_to_table
    t = d.to_table('rows')
    assert_equal [['var0', 'var1'], ["var0's value", "var1's value"], ["var0's value", "var1's value"]], t
  end
end