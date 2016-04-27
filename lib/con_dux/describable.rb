module Describable
  @docs

  def set_docs(args)
    @docs = args[:docs] || [nil, nil, nil]
    @docs[0] = args[:name] || ['reserved']
    @docs[1] = args[:brief_descr]
    @docs[2] = args[:long_descr]
  end

  attr_reader :docs

  def brief_description
    docs[1]
  end

  def long_description
    docs[2]
  end

  def name
    docs[0]
  end
end