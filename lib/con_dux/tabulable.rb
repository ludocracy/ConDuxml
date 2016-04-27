require_relative 'doc_objects/table'

module Tabulable
  include Enumerable
  include ConDux

  @rows
  attr_reader :rows

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
    table_rows = rows.collect do |r| r.to_row end
    [to_header(pattern), *table_rows.compact]
  end

  def matches?(var, pattern)
    var==:@rows || pattern && pattern.include?(var.to_s[1..-1])
  end
end