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
    # TODO implement #find_child then id targeting!!
  end

  def test_instance_single
    load File.expand_path(File.dirname(__FILE__) + '/../../xml/instances/instance_single.xml')
    r = doc.root.first
    a = r.activate.first
    assert_equal '<e/>', a.to_s
  end
end