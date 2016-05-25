# Copyright (c) 2016 Freescale Semiconductor Inc.

module ConDuxml
  module Describable
    def set_docs(args={})
      args = self if args.empty?
      @name = args[:name]
      @brief_descr = args[:brief_descr] || args.brief_description.text || args.brief_descr.text # TODO make more tolerant
      @long_descr = args[:long_descr] || args.long_description || args.long_descr
    end

    attr_reader :name, :brief_descr, :long_descr

  end
end