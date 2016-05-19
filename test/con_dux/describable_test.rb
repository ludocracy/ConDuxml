require_relative '../../lib/con_dux/describable'
require 'test/unit'

class Dummy
  include Describable
  def initialize
    @var0, @var1, @rows = "var0's value", "var1's value", []
  end
  attr_accessor :rows
end

class DescribableTest < Test::Unit::TestCase
  include Duxml
  def setup
    @d = Dummy.new
    d.rows << Dummy.new << Dummy.new
  end

  attr_reader :d

  def teardown
    # Do nothing
  end

  def test_name
    r = d.to_row('rows')
    assert_equal ["var0's value", "var1's value"], r
  end

  def test_brief
    t = d.to_table('rows')
    assert_equal [['var0', 'var1'], ["var0's value", "var1's value"], ["var0's value", "var1's value"]], t
  end

  def test_long
    x = d.
    answer = %(<table><tgroup cols="2"><thead><row><entry>var0</entry><entry>var1</entry></row></thead><tbody><row><entry>var0's value</entry><entry>var1's value</entry></row><row><entry>var0's value</entry><entry>var1's value</entry></row></tbody></tgroup></table>)
    assert_equal answer, x.to_s
  end
end