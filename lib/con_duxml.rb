# Copyright (c) 2016 Freescale Semiconductor Inc.
%w(transform array instance link).each do |f| require_relative "con_duxml/#{f}" end

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
    transforms = case transforms
                   when Doc then transforms.root
                   when Element then transforms
                   when String then sax(transforms).root
                   else
                 end
    @src_doc = case doc_or_path
             when Doc then doc_or_path
             when String then sax doc_or_path
             else
           end
    @src_ns = transforms[:src_ns]
    src_node = src_doc.locate(add_name_space_prefix(transforms[:source])).first
    doc.grammar = transforms[:grammar] if transforms[:grammar]
    doc.history.strict?(false) if opts[:strict].is_a?(FalseClass)
    add_observer doc.history
    a = activate(transforms.first, src_node).first
    @doc << a
  end

  attr_reader :src_doc

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
