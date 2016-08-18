# Copyright (c) 2016 Freescale Semiconductor Inc.
require 'duxml'
require_relative 'con_duxml/designable'

module ConDuxml
  include Duxml

  # hash where each key is concatenation of each instantiation of @doc and values are the Doc instance permutations returned by #instantiate
  @instances
  # double-key hash containing every result of #transform; keys are arguments to transform and key of instance used to create it
  @transforms

  # @param source [String, Doc] XML document or path to one that will provide content to be transformed; source file can
  #   also contain directives or links to them
  # @param directives [TransformClass, String, Doc] either a transform object or directives file or path to one; this
  #   argument is optional and the user can provide a block instead
  # @param block [block] if block given, each node of source is yielded to user-provided transform code
  # @return [Doc] result of transform; automatically hashed into @transforms
  def transform(source, directives=nil, &block)

  end

  # instantiation takes a static design file and constructs a dynamic model by identifying certain keyword elements,
  # executing their method on child nodes, then removing the interpolating keyword element. these are:
  #
  # <array> - is replaced by multiple copies of its direct child or referenced XML nodes, allowing for user-defined variations between each copy
  # <instance> - when it contains design elements, it is removed but its reference ID is given to all children creating an XML-invisible arbitrary grouping
  #   when it references an XML file, ID or path to an XML element, the target is copied and inserted in place of this element
  # <link> - referenced XML file or nodes provides namespace, contents, and notification of changes to any direct children of this node @see ConDuxml::Link
  #
  # @param source [String, Doc] XML document or path to one that will provide design content
  # @param block [block] yields each node of source to block where user can define behaviors for each node
  # @return [Doc] resulting XML document
  def instantiate(source, &block)

  end
end
