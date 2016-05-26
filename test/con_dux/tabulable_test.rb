require_relative '../../lib/con_dux/tabulable'
require_relative '../../lib/duxml_ext/element'
require 'test/unit'


class TabulableTest < Test::Unit::TestCase
  include ConDuxml
  def setup
    @d = Element.new('root', [Element.new('child'), Element.new('child')])
    d.nodes[0][:var0] = "var0's value"
    d.nodes[0][:var1] = "var1's value"
    d.nodes[1][:var0] = "var0's value"
    d.nodes[1][:var1] = "var1's value"
    d.extend Tabulable
  end

  attr_reader :d

  def teardown
    # Do nothing
  end

  def test_to_header
    h = d.nodes.first.to_header
    assert_equal ['var0', 'var1'], h

    h = d.nodes.first.to_header('var0')
    assert_equal ['var1'], h
  end

  def test_to_row
    r = d.nodes.first.to_row('rows')
    assert_equal ["var0's value", "var1's value"], r
  end

  def test_to_table
    t = d.to_table('rows')
    assert_equal [['var0', 'var1'], ["var0's value", "var1's value"], ["var0's value", "var1's value"]], t
  end

  def test_dita_table
    x = d.dita_table
    answer = %(<table><tgroup cols="2"><thead><row><entry>var0</entry><entry>var1</entry></row></thead><tbody><row><entry>var0's value</entry><entry>var1's value</entry></row><row><entry>var0's value</entry><entry>var1's value</entry></row></tbody></tgroup></table>)
    assert_equal answer, x.to_s
  end
end