# Copyright (c) 2016 Freescale Semiconductor Inc.

module ConDuxml
  # <transform> key element is activated by ConDuxml#transform during pre-order traversal of <transforms> file.
  # when activated in turn, each returns a transformation of source nodes referenced by transform's @target attribute.
  # attributes and children of transform provide input and permutation options to transform operation
  module Transform
    # @param source [Doc] XML document containing content to be transformed
    # @return [Array[Element]] transformed content; always an array of nodes, even if just one
    def activate(source)
      target = self[:target] ? source.locate(get_target) : source.root
      [target].flatten.collect do |subj|
        subj.send(get_method, *get_args)
      end
    end

    private

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

  module Transforms
    include Transform
  end
end