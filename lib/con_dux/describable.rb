module Describable
  @docs

  def set_docs(args)
    @name = args[:name] || ['reserved']
    @brief_descr = args[:brief_descr] if args[:brief_descr]
    @long_descr = args[:long_descr] if args[:long_descr]
  end

  attr_reader :name, :brief_descr, :long_descr

  def brief_description
    @brief_descr
  end

  def long_description
    @long_descr
  end
end