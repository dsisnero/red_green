module RedGreen
  # List wrapper for syntax tokens.
  struct SyntaxTokenList
    include Enumerable(SyntaxToken)

    getter items : Array(SyntaxToken)

    def initialize(@items : Array(SyntaxToken) = [] of SyntaxToken)
    end

    def each(&block : SyntaxToken ->)
      @items.each(&block)
    end

    def size : Int32
      @items.size
    end

    def empty? : Bool
      @items.empty?
    end
  end
end
