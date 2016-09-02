# Copyright (c) 2016 Freescale Semiconductor Inc.
require_relative 'duxml_ext/element'

module ConDuxml
  # Instances are copies of another XML element with a distinct set of parameter values
  # like Objects in relation to a Class
  module Instance
    def ref=(target)
      raise Exception unless target.respond_to?(:nodes) or File.exists?(target)
      @ref = target
    end

    def resolve_ref(attr='ref')
      source = if self[:file]
                 path = File.expand_path(File.dirname(doc.path) + '/' + self[:file])
                 sax path
               else
                 doc
               end
      return source.locate self[attr] if self[attr]
      [source.root]
    end

    # creates copy of referent (found from context given by 'meta') at this element's location
    def instantiate
      targets = resolve_ref
      targets = nodes if targets.empty?
      targets.collect do |targe| targe.instantiate end
    end # def instantiate
  end # module Instance

  class InstanceClass
    include Instance
  end
end # module Dux