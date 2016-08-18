# Copyright (c) 2016 Freescale Semiconductor Inc.
require 'ruby-dita'

module ConDuxml
  module Tabulable
    include Duxml
    include Enumerable
    include Dita

    class << self
      def initialize(nodes)
        @nodes = nodes
      end
    end

    extend self

    def each(&block)
      yield nodes.each
    end

    # takes self and renders as array of attribute values
    # generally applies to any object that is a member of a collection of similar objects with similar
    # attributes and/or node structure
    # self can be an XML node
    # filter pattern must be in form that can be safely passed via XML arguments
    # valid formats are:
    # Hash - where the keys are the names of attributes and values are transforms to apply to attr value
    # Array - where each element, in order is the name of the desired attributes/children
    # String - space-separated list of attr names
    # if no pattern is provided, defaults to no filter
    # @param pattern [*several_variants] pattern used to filter attributes to output
    # @return [Array] array of values of attributes that pass filter
    def to_row(pattern=nil)
      if pattern[:to_row]
        pattern[:to_row].split(' ').collect do |p|
          result = case
                     when attributes[p] then attributes[p.to_sym]
                     when find(p).is_a?(Element) then find(p).text
                     else eval(p)
                   end
          result.to_s
        end
      end
    end

    # @param pattern [String, Array]
    # @return [Array] array of names of attributes that pass filter
    def to_header(pattern)
      case pattern.class
        when String   then separate
        when Array    then pattern
        else
          nil
      end
    end

    # @param pattern [Hash, String, Symbol, Array] @see #to_row @param
    # @return [Array] 2D array where columns match #to_header and rows are #to_row output of constituent elements
    def to_table(pattern=nil)
      similar_nodes = nodes.group_by do |n|
        n.name
      end.find do |type, grp|
        grp.size > 1
      end.last
      table_nodes = similar_nodes.collect do |r|
        row_pattern = pattern.is_a?(Array) ? pattern.first : pattern
        r.to_row
        r.to_row(row_pattern)
      end
      header = similar_nodes.first.to_header(pattern.is_a?(Array) ? pattern.last : pattern)
      raise Exception, "number of header columns (#{header.size}) does not match number of data columns (#{table_nodes.first.size})!" if header.size != table_nodes.first.size
      [header, *table_nodes]
    end

    # @param *cols [*[]] column information bound to key, each of which must match a header item
    def dita_table(pattern=nil, cols)
      load Doc.new
      src_tbl = to_table(pattern)
      t = Element.new('table')
      doc << t

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

    private

    def matches?(attr, pattern)
      return false if pattern.nil? or pattern.empty?
      var = attr.to_s[0] == '@' ? attr.to_s[1..-1] : attr.to_s
      pattern = pattern.keys.collect do |k| k.to_s end if pattern.is_a?(Hash)
      var=='nodes' || pattern && var.match(pattern.to_s).to_s == var
    end

    def space_separated_strings(str)
      # should identify groups of space-separated strings
    end
  end # module Tabulable
end