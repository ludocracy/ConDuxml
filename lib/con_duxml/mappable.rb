# Copyright (c) 2016 Freescale Semiconductor Inc.
require 'ruby-dita'

module ConDuxml
  module Mappable
    include Dita

    # TODO currently returns topic, need to make it return map later!
    def dita_map(*targets)
      load Doc.new
      doc << t = Element.new('topic')
      t << Element.new('title')
      t.title << targets.first if targets.any?
      t << Element.new('body')
      t[:id] = "topic#{t.object_id.to_s}"
      targets[1..-1].compact.each do |x| t.body << x end
      t
    end
  end
end