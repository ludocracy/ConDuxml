require 'duxml'

module ConDuxml
  # ConDuxml defines a new Element class by subclassing Duxml's Element and adding #split and #merge transform methods
  class Element < ::Duxml::Element
    # @param &block [Block] calls Enumerable#chunk on this element's nodes to group them by result of &block
    # @return [Element] a duplicate element of this node initialized with each subset's nodes
    def split(&block)
      chunks = nodes.chunk(&block)
      chunks.collect do |type, nodes|
        self.class.new(name, nodes)
      end
    end

    # @param pattern [several_variants] if String/Symbol or array of such, differences between merged entities' instance vars matching pattern are masked; if pattern is a hash, the key is the instance var, and the value becomes the new value for the merged entity
    # @param &block [block] groups nodes by &block then merges each group into a single row @see #chunk
    def merge(pattern=nil, &block)
      self_clone = self.clone
      self_clone.nodes = []
      chunks = block_given? ? nodes.chunk(&block) : [nil, nodes.dup]
      chunks.each do |type, chunk|
        if chunk.size == 1
          self_clone.nodes << chunk.first
          next
        end

        merged_args, homogeneous = diff_attrs(chunk, pattern)
        if homogeneous
          self_clone.nodes << chunk.first.class.new(chunk.first.name, merged_args)
        else
          self_clone << chunk
        end
      end # chunks.each do |type, nodes|
      self_clone
    end # def merge(pattern, &block)

  private
    def diff_attrs(chunk, pattern)
      homogeneous = true
      merged_args = {}
      chunk.each do |node|
        node.attributes.each do |attr, val|
          case
            when pattern && pattern.is_a?(Hash)
              pattern.each do |k,v|
                if attr.match(k.to_s).to_s == attr
                  merged_args[k] = v
                else
                  merged_args[attr] ||= val
                end
              end
            when pattern && pattern.is_a?(Array)
              pattern.each do |p|
                merged_args.merge! diff_attrs(chunk, p) if matches?(attr, p)
              end
            when pattern && matches?(attr, pattern)   then merged_args[attr] ||= val
            when pattern && !matches?(attr, pattern)  then merged_args[attr] ||= val
            when chunk.any? do |n| val != n[attr] end then homogeneous = false; next
            else
          end
        end
      end
      return merged_args, homogeneous
    end

    # TODO add !pattern or at least rewrite to work with XML
    def matches?(attr, pattern)
      var = attr.to_s[0] == '@' ? attr.to_s[1..-1] : attr.to_s
      pattern = pattern.keys.collect do |k| k.to_s end if pattern.is_a?(Hash)
      var=='nodes' || pattern && var.match(pattern.to_s).to_s == var
    end
  end
end