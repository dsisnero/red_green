require "weak_ref"

module RedGreen
  # Cache for green nodes with configurable strategy.
  class SyntaxNodeCache
    enum Strategy
      Weak
      Strong
    end

    @@strategy : Strategy = Strategy::Weak
    @@weak_cache = Hash(UInt64, WeakRef(GreenNode)).new
    @@strong_cache = Hash(UInt64, GreenNode).new

    def self.strategy : Strategy
      @@strategy
    end

    def self.strategy=(value : Strategy)
      @@strategy = value
    end

    def self.try_get_node(key : UInt64) : GreenNode?
      case @@strategy
      when Strategy::Weak
        @@weak_cache[key]?.try(&.value)
      when Strategy::Strong
        @@strong_cache[key]?
      end
    end

    def self.add(key : UInt64, node : GreenNode) : Nil
      case @@strategy
      when Strategy::Weak
        @@weak_cache[key] = WeakRef.new(node)
      when Strategy::Strong
        @@strong_cache[key] = node
      end
    end

    def self.get_or_add(key : UInt64, & : -> GreenNode) : GreenNode
      if node = try_get_node(key)
        return node
      end

      node = yield
      add(key, node)
      node
    end
  end
end
