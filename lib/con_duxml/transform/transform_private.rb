# Copyright (c) 2016 Freescale Semiconductor Inc.
require 'observer'

# Private is where methods should go that you DO NOT want invoked by a transform file!
module Private
  include Observable

  # @param xform [Element] transform element
  # @param src [Element] XML xform containing content to be transformed
  # @return [Array[Element]] transformed content; always an array of nodes, even if just one
  def activate(xform, src)
    @source = src
    get_sources(xform).collect do |src|
      args = get_args(xform, src)
      meth = get_method(xform)
      a = meth.arity
      if a == -1 or args.size == a or args.size.between?(-1 - a, 0 - a)
        output = meth.call(*args)
      else
        output = ''
      end
      changed
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
  # @param src [Element] source XML Element
  # @return [Array[String, Element]] string returned by self[:args] is separated by ';' into correctly formatted argument values for transform method
  def get_args(xform, src)
    args = xform.attributes.keys.sort.collect do |attr|
      if attr.to_s.match(/arg[0-9]*/)
        arg_str = xform[attr].strip
        case arg_str
          when /,/              then separate_enumerables(arg_str, src)
          when /^([\w]+): (\S.*)$/, /^([\S]+) => (\S.*)$/ then {$1.to_sym => normalize_arg($2, src)}
            when /^'(.+)' => (.+)$/ then {$1 => normalize_arg($2, src)}
          when /\//             then src.locate(add_name_space_prefix arg_str).first
          when /^'([\s\w]+)'$/    then $MATCH
          else # arg is path to node
            target = src.locate(add_name_space_prefix arg_str).first
            target or ''
        end
      end
    end.compact
    children = xform.nodes.collect do |child|
      activate(child, src)
    end
    args << children.flatten if children.any?
    args
  end

  def normalize_arg(str, src)
    case str
      when /'.+'/ then str[1..-2]
      when /^[0-9]$/  then str.to_i
      when 'true' then true
      when 'false' then false
      else src.locate(add_name_space_prefix str).first
    end
  end

  # @param str [String] comma separated values that can be either an array or a Hash
  # @return [Array[String]] returns separated values as array of strings
  def separate_enumerables(str, src)
    words = str.split(',').collect do |w| w.strip end
    h = {}
    a = []
    words.each do |s|
      case s
        when /^'([\s\w]+)'$/ then a << $1
        when /^(\w+): (\S.*)$/, /^(\w+) => (\S.*)$/ then h[$1.to_sym] = normalize_arg($2, src)
        when /^'(.+)' => (\S.*)$/ then h[$1] = normalize_arg($2, src)
        else a << normalize_arg(s, src)
      end
    end
    a.empty? ? h : a
  end


  def add_name_space_prefix(str)
    str
    str.split('/').collect do |w|
      w.match(/\w+/) ? "#{src_ns ? src_ns+':' : ''}#{w}" : w
    end.join('/')
  end
end