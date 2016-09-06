require_relative '../../lib/con_duxml/instance'
require 'test/unit'
require 'duxml'
include ConDuxml
include Duxml

class InstanceTest < Test::Unit::TestCase
  def setup
  end

  attr_reader :d

  def teardown
    # Do nothing
  end

  def test_instantiate
    load File.expand_path(File.dirname(__FILE__) + '/../../xml/instances/instance.xml')
    a = doc.root[1].instantiate.first
    assert_equal '<e/>', a.to_s
  end

  def test_instantiate_file
    load File.expand_path(File.dirname(__FILE__) + '/../../xml/instances/instance_file.xml')
    r = doc.root
    a = r.instantiate.first
    assert_equal '<root/>', a.to_s
  end
end