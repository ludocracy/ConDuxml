require_relative 'designable'

module ConDuxml
  module Instanciable
    include Designable

    def instantiate
      sleep 0
    end
  end
end