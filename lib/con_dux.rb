require 'duxml'
require_relative 'con_dux/design'

module ConDux
  include Duxml

  # @param path [String] path of new XML file to create
  # @return [Doc] new XML document
  def create(path)
    File.write(path, '<topic/>')
    load(path)
  end
end
