# Copyright (c) 2016 Freescale Semiconductor Inc.
require 'duxml'
require_relative 'duxml_ext/transform_class'
require_relative 'transform/transform_private'
include Duxml

# All public methods can be invoked by a transform element; please hide methods you don't want users to invoke in Private
module Transform
  include Observable
  include Private

  # most recent XML node from which content has been taken; for constructing relative paths
  @source

  attr_reader :source

  # @param node [Element] XML node from transform output
  # @return [TransformClass] transform event object from output Doc's history
  def find_xform_event(node)
    @output.history #TODO find transform whose outputs include given node
  end

  # @param node [Element] XML node from transform output
  # @return [Element] XML node that contains instructions for transform used to create given @param node
  def find_transform(node)
    find_xform_event(node).instructions
  end

  # @param node [Element] XML node from transform output
  # @return [Element] XML node that provided content for transformation i.e. source
  def find_source(node)
    find_xform_event(node).input
  end

  # @param path [String] path to node from @source e.g. 'child/grandchild'; target is expected to return ONE child
  #   containing TEXT only
  # @return [String] content of target node
  def content(path)
    @source.locate(add_name_space_prefix path).first.text
  end

  # @param *args [*several_variants] see Duxml::Element#new; the only difference here is that this method has access to the content source
  #   so the arguments can pass in the needed data
  # @return [Element] new element to replace old one
  def element(*args)
    Element.new(*args)
  end

  # @param path [String] path to node from @source
  # @return [Element] a deep copy of the target(s)
  def copy(path)
    @source.locate(add_name_space_prefix path).collect do |node|
      node.dclone
    end
  end
end