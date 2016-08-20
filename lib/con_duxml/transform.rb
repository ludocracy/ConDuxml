# Copyright (c) 2016 Freescale Semiconductor Inc.

# helper methods for converting transform elements into code
module Transform
  # @param node [Element]
  # @param source [Doc] XML document containing content to be transformed
  # @return [Array[Element]] transformed content; always an array of nodes, even if just one
  def activate(node, source)
    target = self[:target] ? source.locate(get_target) : source.root
    [target].flatten.collect do |subj|
      subj.send(get_method, *get_args)
    end
  end

  def get_target
    target_str = self[:target]
    target_str.split('/').collect do |s| "#{self[:ns] ? self[:ns]+':' : ''}#{s}" end.join('/')
  end

  # @return [Method] resolves reference to actual transform method
  def get_method
    self[:method].to_sym
  end

  # @return [Array[*several_variants]] string returned by self[:args] is separated by ';' into correctly formatted argument values for transform method
  def get_args
    self[:args] ? self[:args].split(';').collect do |w| w.strip end : []
  end
end