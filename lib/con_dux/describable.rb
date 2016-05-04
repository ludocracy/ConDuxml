module Describable
  def dita_descr(parent=nil)
    parent ||= []
    n = self[:name] || name || simple_name
    parent << (dita_brief ? "#{dita_brief} (#{n})" : "#{n}")
    #parent << dita_long(parent) if dita_long
    parent
  end

  def dita_brief
    nodes.each do |n|
      # TODO - pull these out as parameters or constants!
      %w(brief_description brief_descr full_name short_desc).each do |w|
        return n.text if w.match n.name
      end
    end
    nil
  end

  def dita_long(parent=nil)
    nodes.each do |n|
      # TODO - pull these out as params or consts!
      %w(long_description long_descr full_descr abstract).each do |w|
        # TODO when parent is not nil, then if content has xml, measure distance between it and parent, then iterate thus:
        # TODO  if parent's children_rule allows XML, add it directly, else...
        # TODO  take parent's suggested children and match to content's possible parents
        # TODO  if match found, insert between parent and content
        # TODO  if not, try suggested grandchildren until match is found
        # TODO add whole ancestry between parent and XML
        return parent.nil? ? true : (Element.new('body') << n.nodes) if w.match n.name
      end
    end
    nil
  end
end