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
  # NOTE: instantiate will run TWICE on content to allow for instantiation of instantiations of instances. However, anything beyond two degrees of content replacement must be done manually by user.
  #
  # @param doc_or_path [String, Doc] XML document or path to one
  # @return [Doc] resulting XML document
  def instantiate(doc_or_path)
    @src_doc = get_doc doc_or_path
    @doc = Doc.new << instantiate_node(src_doc.root)
    doc.traverse do |node|
      if node.name.match(/duxml:/)
        return instantiate(doc)
      end
    end
  end

  private
  # @param node [Element] current node during recursion through source nodes
  # @return [Element] result of instantiation
  def instantiate_node(node)
    new_node = node.stub
    new_node.set_inst! node.inst
    new_children = node.nodes.collect do |src_node|
      if src_node.respond_to?(:nodes)
        src_node.activate.collect do |inst|
          instantiate_node(inst)
        end
      else
        src_node.clone
      end
    end.flatten
    if new_children.any?
      new_node << new_children
    end
    new_node
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
