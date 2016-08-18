require 'duxml/reportable'
module Linkable
  include Reportable

  def linked_by
    @observer_peers.select do |obs|
      %w(grammar history).none? do |type|
        obs.name == type
      end
    end
  end
end