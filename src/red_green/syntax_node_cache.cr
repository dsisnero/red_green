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
    @@strong_keys = Array(UInt64).new
    @@strong_key_head = 0
    @@strong_max_size = 1024

    def self.strategy : Strategy
      @@strategy
    end

    def self.strategy=(value : Strategy)
      @@strategy = value
    end

    def self.strong_max_size : Int32
      @@strong_max_size
    end

    def self.strong_max_size=(value : Int32)
      @@strong_max_size = value
      trim_strong_cache
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
        @@strong_keys << key
        trim_strong_cache
      end
    end

    def self.trim_strong_cache : Nil
      while @@strong_cache.size > @@strong_max_size && @@strong_key_head < @@strong_keys.size
        key = @@strong_keys[@@strong_key_head]
        @@strong_key_head += 1
        @@strong_cache.delete(key)
      end

      # Periodically compact the key queue to avoid unbounded growth.
      if @@strong_key_head > 1024 && @@strong_key_head > (@@strong_keys.size // 2)
        @@strong_keys = @@strong_keys[@@strong_key_head, @@strong_keys.size - @@strong_key_head]
        @@strong_key_head = 0
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
