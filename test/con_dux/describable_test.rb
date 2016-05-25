require_relative '../../lib/con_dux/describable'
require 'test/unit'
require 'duxml'

class Dummy
  include Describable

  def initialize
    set_docs name: 'nombre', brief_descr: 'nombre de la cosa', long_descr: '<p>la descripcion nombre de la cosa puede <b>estilar</b> como <i>deseado</i></p>'
  end

  attr_accessor :rows
end

class DescribableTest < Test::Unit::TestCase
  include Duxml

  def setup
    @d = Dummy.new
  end

  attr_reader :d

  def teardown
    # Do nothing
  end

  def test_name
    r = d.name
    assert_equal 'nombre', r
  end

  def test_brief
    t = d.brief_descr
    assert_equal 'nombre de la cosa', t
  end

  def test_long
    x = d.long_descr
    assert_equal '<p>la descripcion nombre de la cosa puede <b>estilar</b> como <i>deseado</i></p>', x
  end
end