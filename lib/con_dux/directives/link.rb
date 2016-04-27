require File.expand_path(File.dirname(__FILE__) + '/instance')

module Duxml

  # links allow parameters to be bound to attribute values or element content in the design objects wrapped by the link
  class Link < Instance
    attr_reader :ref

    # TODO not sure how to represent this!
    def instantiate(target=nil)
      resolve_ref nil, target
      self
    end
  end
end # module Dux