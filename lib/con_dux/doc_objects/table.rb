require 'duxml'

module ConDux
  class Table
    include Enumerable

    def initialize(*ary)
      @nodes = ary
    end

    attr_accessor :nodes

    alias_method :rows, :nodes

    def each(&block)
      @nodes.each(&block)
    end

    # takes children of table and splits them into multiple tables using given criteria or block to sort
    # e.g.
    #   table = Table.new(['a', 'b'], ['c', 'b'], ['e', 'f'], ['g', 'h'])
    #   a = table.split('rows[1]')
    #   a.first.class
    #     => Table
    #   a[0].to_a
    #     => [['a', 'b'], ['c', 'b']]
    #   a[1].to_a
    #     => [['e', 'f']]
    #   a[2].to_a
    #     => [['g', 'h']]
    def split(proc, &block)
      group_by(&block).collect do |type, group| Table.new proc.call(type, group) end
    end

    # takes children of table and merges rows or columns by applying given rule or block
    # e.g.
    #   table = Table.new(['a', 'b'], ['c', 'b'], ['e', 'f'], ['g', 'h'])
    #   m = table.merge('rows[1]')
    #   m.to_a
    #     => [['a', 'b'], ['e', 'f'], ['g', 'h']]
    #   m = table.merge('rows[1]') do |group|
    #                                     if group.size > 1
    #                                       new_name = group.collect do |row| row.first end.join('-')
    #                                       Row.new(new_name, group.first.last)
    #                                     else
    #                                       group
    #                                     end
    #               end
    #   m.to_a
    #     => [['a-c', 'b'], ['e', 'f'], ['g', 'h']]
    def merge(sym=nil, &block)
      sym ||= :merge_rows
      Table.new(chunk(&block).collect do |type, group| method(sym).call(type, group) end)
    end
  end
end
