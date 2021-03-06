# Copyright (c) 2016 Freescale Semiconductor Inc.
module Linkable
  def linked_by
    @observer_peers.select do |obs|
      %w(grammar history).none? do |type|
        obs.name == type
      end
    end
  end
end
