# Copyright (c) 2016 Freescale Semiconductor Inc.

require File.expand_path(File.dirname(__FILE__) + '/instance')

module ConDuxml
  # XML object array
  # represents a pattern of copies of a this object's children or referents
  # differentiates between copies using iterator Parameter
  module Array
    include Instance
    include Enumerable

    # @param block [block] each duplicated node is yielded to block if given
    # @return [Array[Element]] flattened array of all duplicated Elements
    def instantiate(&block)
      size_expr = size.respond_to?(:to_i) ? size.to_i : size.to_s
      if size_expr.is_a? Fixnum
        new_children = []
        size_expr.times do |index|
          nodes.each do |node|
            new_child = block_given? ? yield(node.dclone, index) : node.dclone
            new_children << new_child
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

    # overriding #each to only traverse children and return self on completion, not Enumerator
    def each &block
      @children.each &block
      self
    end
  end # class Array
end # module Dux