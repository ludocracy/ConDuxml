# Copyright (c) 2016 Freescale Semiconductor Inc.

require File.expand_path(File.dirname(__FILE__) + '/instance')

module ConDuxml
  # XML object array
  # represents a pattern of copies of a this object's children or referents
  # differentiates between copies using iterator Parameter
  module Array
    include Instance
    include Enumerable

    # @return [Array[Element]] flattened array of all duplicated Elements
    def instantiate
      size_expr = size.respond_to?(:to_i) ? size.to_i : size.to_s
      if size_expr.is_a? Fixnum
        new_children = []
        size_expr.times do
          source_nodes = if nodes.empty? and self[:ref]
            resolve_ref
          else
            nodes
          end
          source_nodes.each do |node|
            new_children << node.instantiate
          end
        end
        new_children
      else
        [self]
      end
    end # def instantiate

    # size can be Fixnum or a Parameter expression
    def size
      self[:size]
    end
  end # class Array
end # module Dux