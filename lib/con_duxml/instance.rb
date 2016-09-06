# Copyright (c) 2016 Freescale Semiconductor Inc.
require_relative 'duxml_ext/element'

module ConDuxml
  # Instances are copies of another XML element with a distinct set of parameter values
  # like Objects in relation to a Class
  module Instance
    # @param target [String] path to target node or file
    # @return [Element] self
    def ref=(target)
      raise Exception unless doc.locate(target) or File.exists?(target)
      self[:ref] = target
    end

    # @return [Element] either root node of referenced Doc or referenced node
    def resolve_ref(attr='ref')
      source = if self[:file]
                 path = File.expand_path(File.dirname(doc.path) + '/' + self[:file])
                 sax path
               else
                 doc
               end
      return source.locate(self[attr]).first if self[attr]
      source.root
    end

    # @return [Array[Element, String]] array (or NodeSet) of either shallow clone of child nodes or referenced nodes @see #ref=
    def instantiate
      [resolve_ref.clone] or nodes.clone
    end # def instantiate
  end # module Instance

  class InstanceClass
    include Instance
  end
end # module Dux