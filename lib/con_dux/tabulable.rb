require 'duxml'

module ConDuxml
  module Tabulable
    include Enumerable
    include ConDuxml

    class << self
      def initialize(nodes)
        @nodes = nodes
      end
    end

    extend self

    def each(&block)
      yield nodes.each
    end

    def to_row(pattern=nil)
      entries = []
      nodes.each do |n| entries << n.nodes.first if n.nodes.size == 1 && nodes.first.is_a?(String) && !matches?(n.name, pattern) end
      if respond_to?(:attributes) && attributes.any?
        attributes.each do |k, v| entries << v unless matches?(k, pattern) end
      else
        instance_variables.each do |var|
          entries << instance_variable_get(var) unless matches?(var, pattern)
        end
      end
      entries
    end

    def to_header(pattern=nil)
      headings = []
      nodes.each do |n| headings << n.name if n.nodes.size == 1 && n.nodes.first.is_a?(String) && !matches?(n.name, pattern) end
      if respond_to?(:attributes) && attributes.any?
        attributes.each do |k, v| headings << k unless matches?(k, pattern) end
      else
        instance_variables.each do |var|
          headings << var.to_s[1..-1] unless matches?(var, pattern)
        end
      end
      headings
    end

    def to_table(pattern=nil)
      similar_nodes = nodes.group_by do |n|
        n.name
      end.find do |type, grp|
        grp.size > 1
      end.last
      table_nodes = similar_nodes.collect do |r| r.to_row(pattern) end
      [similar_nodes.first.to_header(pattern), *table_nodes]
    end

    # @param *cols [*[]] column information bound to key, each of which must match a header item
    def dita_table(pattern=[], *cols)
      src_tbl = to_table(pattern)
      t = Element.new('table')
      cols.each do |c|
        t << Element.new('colspec')
        t.nodes.last[:colname] = c.name
        # TODO pull other colspec attrs; look them up!!
      end
      tgroup = Element.new('tgroup')
      tgroup << Element.new('thead')
      tgroup.thead << Element.new('row')

      src_tbl.first.each do |h|
        entry = Element.new('entry')
        entry << h
        tgroup.thead.row << entry
      end

      tgroup[:cols] = src_tbl.first.size.to_s

      tgroup << Element.new('tbody')
      src_tbl[1..-1].each do |row|
        tgroup.tbody << Element.new('row')
        row.each do |e|
          entry = Element.new('entry')
          entry << e.to_s
          tgroup.tbody.nodes.last << entry
        end
      end
      t << tgroup
    end # def to_dita(pattern=[], *cols)
  end # module Tabulable
end