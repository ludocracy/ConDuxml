require_relative '../../lib/con_dux/mappable'
require 'test/unit'

class Dummy
  include Mappable
  def initialize
    @var0, @var1, @nodes = "var0's value", "var1's value", []
  end
  attr_accessor :nodes
end

class MappableTest < Test::Unit::TestCase
  include Duxml

  def setup
    @d = Dummy.new
  end

  attr_reader :d

  def teardown
    # Do nothing
  end

  def test_topicize
    r = d.to_dita
    File.write 'test.dita', r
    #assert_equal answer[0].to_s, r.to_s
  end
end