require 'duxml'
require_relative 'doc_objects/table'

module Tabulable
  include Enumerable
  include ConDux
  include Duxml

  class << self
    def initialize(rows)
      @rows = rows
    end
  end

  extend self

  @rows
  attr_accessor :rows

  # returns two or more tables based on chunk criteria
  def split(&block)
    chunks = rows.chunk(&block)
    chunks.collect do |type, rows|
      self.class.new({name: type, rows: rows})
    end
  end

  # @param pattern [several_variants] if String/Symbol or array of such, differences between merged entities' instance vars matching pattern are masked; if pattern is a hash, the key is the instance var, and the value becomes the new value for the merged entity
  # @param &block [block] groups rows by &block then merges each group into a single row @see #chunk
  def merge(pattern, &block)
    self_clone = self.clone
    self_clone.rows = []
    chunks = rows.chunk(&block)
    chunks.each do |type, rows|
      new_row_args = {}
      result_array_hash = {}
      dont_merge = false

      if rows.size == 1
        self_clone.rows << rows.first
        next
      end
      rows.first.instance_variables.each do |var|
        result_array_hash[var.to_s[1..-1].to_sym] = rows.collect do |row| row.instance_variable_get(var) end
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
        self_clone.rows + rows
      else
        self_clone.rows << rows.first.class.new(new_row_args)
      end
    end # chunks.each do |type, rows|
    self_clone
  end # def merge(pattern, &block)

  def each(&block)
    yield rows.each
  end

  def to_row(pattern=nil)
    instance_variables.collect do |var|
      instance_variable_get(var) unless matches?(var, pattern)
    end.compact
  end

  def to_header(pattern=nil)
    instance_variables.collect do |var|
      var.to_s[1..-1] unless matches?(var, pattern)
    end.compact
  end

  def to_table(pattern=nil)
    table_rows = rows.collect do |r| r.to_row(pattern) end
    [rows.first.to_header(pattern), *table_rows.compact]
  end

  def matches?(var, pattern)
    var = var.to_s[0] == '@' ? var.to_s[1..-1] : var.to_s
    pattern = pattern.keys.collect do |k| k.to_s end if pattern.is_a?(Hash)
    var=='rows' || pattern && pattern.include?(var)
  end

  # @param *cols [*[]] column information bound to key, each of which must match a header item
  def to_dita(pattern=[], *cols)
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