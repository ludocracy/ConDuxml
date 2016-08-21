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

    def resolve_ref(attr=nil)
      @ref ||= self[attr || :ref]
    end

    # creates copy of referent (found from context given by 'meta') at this element's location
    def instantiate
      new_kids = []
      target = resolve_ref
      if target.nil?
        new_kids = nodes
      else
        new_kids << target.dclone
      end
      new_kids
    end # def instantiate
  end # module Instance

  class InstanceClass
    include Instance
  end
end # module Dux