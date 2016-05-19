# Copyright (c) 2016 Freescale Semiconductor Inc.

require_relative 'describable'
require_relative 'tabulable'
require_relative 'mappable'

module ConDuxml
  module Designable
    include Describable
    include Tabulable
    include Mappable
  end
end