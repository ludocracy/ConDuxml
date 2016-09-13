module Duxml
  class Doc
    # @param id [String, Symbol] document-unique id attribute value
    # @return [Element, NilClass] found element or nil if not found
    def find_by_id(id)
      id_str = id.to_s
      return @id_hash[id_str] if @id_hash[id_str]
      root.traverse do |node|
        if node.respond_to?(:nodes)
          if node[:id] == id_str or id_str == node.inst[:id]
            return @id_hash[id_str] = node
          end
        end
      end
      nil
    end
  end
end