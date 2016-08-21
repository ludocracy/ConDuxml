# Copyright (c) 2016 Freescale Semiconductor Inc.

require File.expand_path(File.dirname(__FILE__) + '/instance')

module ConDuxml
  # links are effectively aliases for an XML node that can exist anywhere outside of that node
  # they confer referencing scope, namespace, and notifications of content changes
  # anything contained by a link element is then dynamically linked to the target
  # this is useful for designs where one element's state depends on another's or where it's important to track a target
  # that may not be in a fixed location
  module Link
    include Instance

    # strict links will immediately throw an exception if the target becomes invalid for any reason
    # otherwise, errors are simply reported to history
    @strict_or_false

    def valid?
      !resolve_ref.nil?
    end

    def ref=(target)
      target.extend Linkable
      @ref = target
    end

    # @param block [block] each child node is yielded to block if given
    # @return [Array] nodes to replace this link - children by default
    def instantiate(&block)
      resolve_ref.add_observer(self)
      block_given? ? yield(nodes.each) : nodes
    end

    # @param bool [true, false, nil] if true or false, sets @strict_or_false to this value
    # @return [true, false] returns current value (true by default)
    def strict?(bool=nil)
      bool.nil? ? @strict_or_false ||= true : @strict_or_false = bool
    end

    # TODO rewrite this!!! at most primitive, updates need to happen when link targets split/merge or are removed
    # @param type [Symbol] category i.e. class symbol of changes/errors reported
    # @param *args [*several_variants] information needed to accurately log the event; varies by change/error class
    def update(type, *args)
      change_class = Duxml::const_get "#{type.to_s}Class".to_sym
      change_comp = change_class.new *args
      @nodes.unshift change_comp
      changed
      notify_observers(change_comp) unless change_comp.respond_to?(:error?)
      raise(Exception, change_comp.description) if strict? && type == :QualifyError
    end
  end
end # module Dux