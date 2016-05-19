# Copyright (c) 2016 Freescale Semiconductor Inc.

require File.expand_path(File.dirname(__FILE__) + '/parameters')

module Duxml
  # Instances are copies of another XML element with a distinct set of parameter values
  # like Objects in relation to a Class
  class Instance
    # returns parameters or empty array
    def params
      p = find_child 'parameters'
      p.simple_class == 'parameters' ? p : []
    end

    # creates copy of referent (found from context given by 'meta') at this element's location
    def instantiate(meta=nil)
      new_kids = []
      target = resolve_ref :ref, meta
      if target.nil?
        children.each do |child|
          new_kids << child if child.simple_class != 'parameters'
        end
      else
        new_kid = target.clone
        new_kid.rename "#{id}.#{target.id}"
        new_kids << new_kid
      end
      new_kids
    end # def instantiate
  end # class Instance

  # root element for an XML file that is entirely parameterized
  class Design < Instance; end
end # module Dux