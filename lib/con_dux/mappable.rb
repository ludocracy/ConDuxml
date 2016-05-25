# Copyright (c) 2016 Freescale Semiconductor Inc.
require 'ruby-dita'

module ConDuxml
  module Mappable
    include Dita

    def topicize(*args)
      # TODO move to bin! and add actual test!
      t = Element.new('topic')
      t << Element.new('title')
      t.title << args.first
      t << Element.new('body')
      t[:id] = "topic#{t.object_id.to_s}"
      args[1..-1].compact.each do |x| t.body << x end
      Doc.new << t
    end

    def to_map

    end

    def to_dita
      raise Exception unless respond_to?(:nodes)

      topicize nodes
    end

    def depth
      0 # TODO - make this dynamic! Duxml needs to implement tree depth method
    end
  end
end