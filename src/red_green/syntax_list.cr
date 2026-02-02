module RedGreen
  # Typed wrapper over a list of syntax nodes.
  struct SyntaxList(T)
    include Enumerable(T)

    getter items : Array(T)

    def initialize(@items : Array(T) = [] of T)
    end

    def each(&block : T ->)
      @items.each(&block)
    end

    def size : Int32
      @items.size
    end

    def empty? : Bool
      @items.empty?
    end

    def [](index : Int32) : T
      @items[index]
    end
  end
end
