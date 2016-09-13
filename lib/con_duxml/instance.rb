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
    def resolve_ref
      source = if self[:file]
                 path = File.expand_path(File.dirname(doc.path) + '/' + self[:file])
                 sax path
               else
                 doc
               end
      if self[:ref]
        if Regexp.nmtoken.match(self[:ref]).to_s == self[:ref] and source.find_by_id(self[:ref])
          return source.find_by_id self[:ref]
        else
          return source.locate(self[:ref]).first
        end
      elsif self[:file]
        source.root
      else
        nil
      end
    end

    # @return [Array[Element, String]] array (or NodeSet) of either shallow clone of child nodes or referenced nodes @see #ref=
    def activate
      [resolve_ref || nodes].flatten.clone.collect do |node|
        node.set_inst! self
      end
    end # def instantiate
  end # module Instance
end # module Dux