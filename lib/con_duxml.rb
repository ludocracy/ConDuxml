# Copyright (c) 2016 Freescale Semiconductor Inc.
%w(transform instance link).each do |f| require_relative "con_duxml/#{f}" end

module ConDuxml
  include Duxml
  include Transform

  # namespace prefix for source file
  @src_ns

  attr_reader :src_ns

  # @param transforms [String, Doc] transforms file or path to one
  # @param doc_or_path [String, Doc] XML document or path to one that will provide content to be transformed
  # @param opts [Hash] more to come TODO
  #   :strict => [boolean] # true by default, throws errors when transform results violate given grammar; if false,
  #                        # saves error to doc.history and resumes transform
  # @return [Doc] result of transform; automatically saved to @doc
  def transform(transforms, doc_or_path, opts={})
    @doc = Doc.new
    transforms = get_doc(transforms).root
    @src_doc = get_doc doc_or_path
    @src_ns = transforms[:src_ns]
    src_node = src_doc.locate(add_name_space_prefix(transforms[:source])).first
    doc.grammar = transforms[:grammar] if transforms[:grammar]
    doc.history.strict?(false) if opts[:strict].is_a?(FalseClass)
    add_observer doc.history
    @doc << activate(transforms.first, src_node).first
  end

  attr_reader :src_doc

  # instantiation takes a static design file and constructs a dynamic model by identifying certain keyword elements,
  # executing their method on child nodes, then removing the interpolating keyword element. these are:
  #
  # <instance> - when it contains design elements, it is removed but its reference ID is given to all children creating an XML-invisible arbitrary grouping
  #   when it references an XML file, ID or path to an XML element, the target is copied and inserted in place of this element
  # <link> - referenced XML file or nodes provides namespace, contents, and notification of changes to any direct children of this node @see ConDuxml::Link
  #
  # @param doc_or_node [String, Doc, Element] XML document or path to one or XMl Element
  # @return [Doc] resulting XML document
  def instantiate(doc_or_node, opts={})
    if doc_or_node.is_a?(Element)
      new_node = doc_or_node.stub
      new_children = doc_or_node.nodes.collect do |src_node|
        if src_node.respond_to?(:nodes)
          src_node.activate.collect do |inst|
            inst.name.match(/con_duxml:/) ? instantiate(src_node) : instantiate(inst)
          end
        else
          src_node.clone
        end
      end.flatten
      if new_children.any?
        new_node << new_children
      end
      new_node
    else
      @src_doc = get_doc doc_or_node
      instance = instantiate(src_doc.root)
      @doc = Doc.new << instance
    end
  end

private
  def get_doc(doc_or_path)
    case doc_or_path
      when Doc then doc_or_path
      when String then sax doc_or_path
      when Element then doc_or_path
      else
    end
  end
end
