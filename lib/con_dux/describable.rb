# Copyright (c) 2016 Freescale Semiconductor Inc.

module ConDuxml
  module Describable
    # TODO make this safer!!! fails too easily
    def set_docs(args={})
      args = self if args.empty?
      @brief_descr = args.is_a?(Hash) ? args[:brief_descr] : (args.brief_description.text || args.brief_descr.text)
      @long_descr = args.is_a?(Hash) ? args[:long_descr] : ( args.long_description.nodes || args.long_descr)
    end

    attr_reader :brief_descr, :long_descr
  end
end