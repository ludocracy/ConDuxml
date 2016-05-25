# Copyright (c) 2016 Freescale Semiconductor Inc.

require File.expand_path(File.dirname(__FILE__) + '/instance')

module ConDuxml
  # XML object array
  # represents a pattern of copies of a this object's children or referents
  # differentiates between copies using iterator Parameter
  module Array
    include Instance
    include Enumerable

    # reifies pattern by actually copying children and assigning each unique properties derived from iterator value
    # TODO do we need argument?
    def instantiate(meta=nil)
      size_expr = size.respond_to?(:to_i) ? size.to_i : size.to_s
      if size_expr.is_a? Fixnum
        iterator_index = 0
        new_children = []
        kids = []
        children.each do |kid| kids << kid.detached_subtree_copy end
        remove_all!
        size_expr.times do
          i = Instance.new
          i << Parameters.new(nil, iterator: iterator_index)
          kids.each do |kid| i << kid.detached_subtree_copy end
          i.rename name+iterator_index.to_s
          new_children << i
          iterator_index += 1
        end
        new_children
      else
        []
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