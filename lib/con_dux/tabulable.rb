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

    @nodes
    attr_accessor :nodes

    # returns two or more tables based on chunk criteria
    def split(&block)
      chunks = nodes.chunk(&block)
      chunks.collect do |type, nodes|
        self.class.new({name: type, nodes: nodes})
      end
    end

    # @param pattern [several_variants] if String/Symbol or array of such, differences between merged entities' instance vars matching pattern are masked; if pattern is a hash, the key is the instance var, and the value becomes the new value for the merged entity
    # @param &block [block] groups nodes by &block then merges each group into a single row @see #chunk
    def merge(pattern, &block)
      self_clone = self.clone
      self_clone.nodes = []
      chunks = nodes.chunk(&block)
      chunks.each do |type, nodes|
        new_row_args = {}
        result_array_hash = {}
        dont_merge = false

        if nodes.size == 1
          self_clone.nodes << nodes.first
          next
        end
        nodes.first.instance_variables.each do |var|
          result_array_hash[var.to_s[1..-1].to_sym] = nodes.collect do |row| row.instance_variable_get(var) end
        end

        result_array_hash.each do |var, values|
          if values.all? do |val| val == values.first end
            new_row_args[var] = values.first
          else
            # difference found!
            if matches?(var, pattern)
              if pattern.is_a?(Hash)
                if pattern[var].respond_to?(:call)
                  new_row_args[var] = pattern[var].call(values)
                else
                  new_row_args[var] = pattern[var] ? pattern[var] : values.first
                end
              else
                new_row_args[var] = values.first
              end
            else
              dont_merge = true
            end # if... else... matches?(var, pattern)
          end # if... else... values.all? do |val| val == values.first end
        end # result_array_hash.each do |var, values|
        if dont_merge
          self_clone.nodes + nodes
        else
          self_clone.nodes << nodes.first.class.new(new_row_args)
        end
      end # chunks.each do |type, nodes|
      self_clone
    end # def merge(pattern, &block)

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

    def matches?(var, pattern)
      var = var.to_s[0] == '@' ? var.to_s[1..-1] : var.to_s
      pattern = pattern.keys.collect do |k| k.to_s end if pattern.is_a?(Hash)
      var=='nodes' || pattern && pattern.include?(var)
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