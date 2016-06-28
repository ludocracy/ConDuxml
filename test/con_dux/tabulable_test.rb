require_relative '../../lib/con_dux/tabulable'
require 'test/unit'

include ConDuxml

class Element < ::Duxml::Element
  include Tabulable

  def <<(obj)
    super(obj)
    obj.extend Tabulable
  end
end

class TabulableTest < Test::Unit::TestCase

  def setup
    @d = Element.new('root', [Element.new('child'), Element.new('child')])
    d.nodes[0][:var0] = "var0's value"
    d.nodes[0][:var1] = "var1's value"
    d.nodes[1][:var0] = "var0's value"
    d.nodes[1][:var1] = "var1's value"
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

    h = d.nodes.first.to_header(['variable 0', 'variable 1'])
    assert_equal ['variable 0', 'variable 1'], h
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
    assert_raise(Exception, '') do
      x << Element.new('bogus')
    end
  end
end