# Copyright (c) 2016 Freescale Semiconductor Inc.

require File.expand_path(File.dirname(__FILE__) + '/instance')

module ConDuxml
  # links allow parameters to be bound to attribute values or element content in the design objects wrapped by the link
  module Link
    include Instance

    def valid?
      !resolve_ref.nil?
    end

    def ref=(target)
      target.add_observer(self, :ref=)
      super target
    end

    def instantiate
      [resolve_ref]
    end
  end

  module Linkable
    include Reportable

    def linked_by
      @observer_peers.select do |obs|
        %w(grammar history).none? do |type| obs.name == type end
      end
    end
  end
end # module Dux