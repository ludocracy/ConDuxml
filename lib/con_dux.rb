# Copyright (c) 2016 Freescale Semiconductor Inc.

require_relative 'con_dux/designable'

module ConDuxml
  include Duxml

  def instantiate(parent=nil)
    if parent.nil?
      new_doc = Doc.new
      parent = doc.root
      new_doc << parent.dup
    end

    input = parent.nodes.dup
    output = []
    until input.empty? do
      n = input.shift
      if n.respond_to?(:instantiate)
        output << n.instantiate
      else
        output << n.dup # TODO - not detached?
      end
    end
  end
end
