# Copyright (c) 2016 Freescale Semiconductor Inc.
require 'duxml'
require_relative 'con_duxml/designable'

module ConDuxml
  include Duxml

  # hash where each key is concatenation of each instantiation of @doc and values are the Doc instance permutations returned by #instantiate
  @instances
  # double-key hash containing every result of #transform; keys concatenation of source doc's #object_id and transform doc's #object_id
  @transforms

  # @param transforms [String, Doc] transforms file or path to one
  # @param doc_or_path [String, Doc] XML document or path to one that will provide content to be transformed; source file can
  #   also contain directives or links to them
  # @return [Doc] result of transform; automatically hashed into @transforms
  def transform(transforms, doc_or_path=nil)
    transformed = Doc.new
    @doc = doc_or_path.is_a?(Doc) ? doc_or_path.root : sax(doc_or_path)
    transformed.grammar = transforms[:grammar] if transforms[:grammar]
    cursors = [transformed]
    transforms.traverse do |node|
      cursor = cursors.shift
      transformed_node = node.activate doc
      cursor << transformed_node
      if node.nodes.any?
        cursors << transformed_node
      end
    end

    @transforms[doc.object_id+transforms.object_id] = transformed
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
  # @return [Doc] resulting XML document
  def instantiate(source)

  end
end
