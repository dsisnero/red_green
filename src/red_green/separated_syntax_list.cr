module RedGreen
  # Typed list of nodes with separators (typically tokens) interleaved.
  struct SeparatedSyntaxList(T)
    include Enumerable(T)

    getter nodes : Array(T)
    getter separators : Array(SyntaxToken)

    def initialize(@nodes : Array(T) = [] of T, @separators : Array(SyntaxToken) = [] of SyntaxToken)
    end

    def each(&block : T ->)
      @nodes.each(&block)
    end

    def size : Int32
      @nodes.size
    end

    def empty? : Bool
      @nodes.empty?
    end

    def [](index : Int32) : T
      @nodes[index]
    end

    def separator_count : Int32
      @separators.size
    end

    def separator_at(index : Int32) : SyntaxToken
      @separators[index]
    end
  end
end
