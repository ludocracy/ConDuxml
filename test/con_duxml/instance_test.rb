require_relative '../../lib/con_duxml/instance'
require 'test/unit'
require 'duxml'
include ConDuxml
include Duxml

class InstanceTest < Test::Unit::TestCase
  def setup
  end

  def teardown
    # Do nothing
  end

  def test_instantiate
    load File.expand_path(File.dirname(__FILE__) + '/../../xml/instances/instance.xml')
    a = doc.root[1].activate.first
    assert_equal '<e/>', a.to_s
  end

  def test_instantiate_file
    load File.expand_path(File.dirname(__FILE__) + '/../../xml/instances/instance_file.xml')
    r = doc.root.first
    a = r.activate.first.stub
    assert_equal '<root/>', a.to_s
  end

  def test_ref_instance_group
    load File.expand_path(File.dirname(__FILE__) + '/../../xml/instances/instance_group.xml')
    r = doc.root.first
    a = r.activate.first.nodes
    assert_equal '[<e/>, <f/>, <g/>]', a.to_s
  end

  def test_instance_single
    load File.expand_path(File.dirname(__FILE__) + '/../../xml/instances/instance_single.xml')
    r = doc.root.first
    a = r.activate.first
    assert_equal '<e/>', a.to_s
  end

  def test_instance_by_id
    load File.expand_path(File.dirname(__FILE__) + '/../../xml/instances/instance_by_id.xml')
    r = doc.root.first
    a = r.activate.first
    assert_equal '<e id="some_id"/>', a.to_s
  end

  def test_instance_of_instance
    load File.expand_path(File.dirname(__FILE__) + '/../../xml/instances/instance_of_instance.xml')
    r = doc.root[1]
    a = r.activate.first.first
    assert_equal '<e/>', a.to_s
  end
end