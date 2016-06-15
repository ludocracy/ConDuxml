# Copyright (c) 2016 Freescale Semiconductor Inc.

require_relative 'con_dux/designable'

module ConDuxml
  include Duxml

  @kanseis

  attr_reader :kanseis

  # @param parent [Doc, Element] XML parent of this node
  # @return [Doc, Element] instantiated XML copy of this node
  def instantiate!
    kansei!

    parent = doc
    doc.traverse do |n|
      next if n.is_a?(String)
      parent.replace(n, n.instantiate) if n.respond_to?(:instantiate)
      parent = n unless parent === n or parent.nodes.any? do |m| m === n end
    end
    doc
  end

  def template
    @kanseis.last
  end

  private

  def kansei!
    new_root = doc.clone
    @kanseis ||= []
    save(file) # TODO make this optional!? probably?
    @kanseis << doc
    @meta = MetaClass.new
    @doc = new_root
  end
end
