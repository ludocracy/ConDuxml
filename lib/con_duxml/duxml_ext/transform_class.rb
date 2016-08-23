require 'duxml/meta/history/change'

include Duxml
class TransformClass < ChangeClass
  def initialize(xform, src, output)
    @instructions = xform
    @input = src
    @output = output
  end

  attr_reader :instructions, :input, :output

  # @return [String] verbal description of transform event
  def description
    "#{output.description} created from #{input.description} by #{instructions.description}"
  end
end
