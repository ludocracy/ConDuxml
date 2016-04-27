require_relative '../../../lib/con_dux/doc_objects/table'
require 'test/unit'

class TableTest < Test::Unit::TestCase
  include ConDux
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @g = Grammar.import(File.expand_path(File.dirname(__FILE__) + '/../../../../Duxml/xml/test_grammar.xml'))
    @t = Table.new(%w(a b), %w(c d), %w(e f), %w(g h))
  end

  attr_reader :t

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_init
    assert_equal %w(a b), t.rows.first
  end

  def test_split
    a = t.split
    assert_equal [[]], a
  end

  def test_merge
    a = t.merge()
    assert_equal [[]], a
  end

  def test_dita
    x = t.dita
    File.write 'table.xml', x.to_s
  end
end