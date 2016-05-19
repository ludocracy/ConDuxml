# Copyright (c) 2016 Freescale Semiconductor Inc.

require_relative 'con_dux/designable'

module ConDux
  # @param path [String] path of new XML file to create
  # @return [Doc] new XML document
  def create(path)
    File.write(path, '<topic/>')
    load(path)
  end
end
