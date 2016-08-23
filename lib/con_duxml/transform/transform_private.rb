# Copyright (c) 2016 Freescale Semiconductor Inc.

# Private is where methods should go that you DO NOT want invoked by a transform file!
module Private
  private

  # @param xform [Element] transform element
  # @param _source [Element] XML xform containing content to be transformed
  # @return [Array[Element]] transformed content; always an array of nodes, even if just one
  def activate(xform, _source)
    @source = _source
    get_sources(xform).collect do |src|
      args = get_args(xform, src)
      output = get_method(xform).call(*args)
      changed
      m = methods
      notify_observers(:Transform, xform, src, output)
      changed false
      output
    end
  end

  # @param xform [Element] transform element
  # @return [Array] array of elements that match @target, which must be a '/'-separated string
  #   if transform element has any children that may need the same source target, target_stack.last remains
  #   if transform is a leaf, target_stack is popped
  def get_sources(xform)
    if xform[:source]
      source.locate add_name_space_prefix xform[:source]
    else
      [source]
    end
  end

  # @param xform [Element] transform element
  # @return [Method] resolves reference to actual transform method
  def get_method(xform)
    words = xform.name.split(':').reverse
    method_name = words[0].to_sym
    maudule = self
    maudule = Module.const_get(words[1].constantize) if words[1] and Module.const_defined?(words[1].constantize)
    if maudule == self
      public_method(method_name)
    else
      maudule.public_instance_method(method_name).bind self
    end
  end

  # @param xform [Element] transform element
  # @param subj [Element] source XML Element
  # @return [Array[String, Element]] string returned by self[:args] is separated by ';' into correctly formatted argument values for transform method
  def get_args(xform, subj)
    args = xform.attributes.keys.sort.collect do |attr|
      if attr.to_s.match(/arg[0-9]*/)
        if xform[attr].include?(',')
          xform[attr].split(',').collect do |s|
            s.match(/'[\s\w]+'/) ? $MATCH.strip[1..-2] : subj.locate(add_name_space_prefix s.strip).first
          end
        elsif xform[attr].include?('/')
          subj.locate(add_name_space_prefix xform[attr]).first
        elsif xform[attr].match(/'[\s\w]+'/)
          $MATCH.strip[1..-2]
        else
          targets = subj.locate(xform[attr])
          targets.empty? ? xform[attr] : targets
        end
      end
    end.compact
    children = xform.nodes.collect do |child|
      activate(child, subj)
    end
    args << children.flatten if children.any?
    args
  end

  def add_name_space_prefix(str)
    str.split('/').collect do |w|
      w.match(/\w+/) ? "#{src_ns ? src_ns+':' : ''}#{w}" : w
    end.join('/')
  end
end