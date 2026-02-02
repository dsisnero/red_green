module RedGreen
  # List wrapper for syntax trivia.
  struct SyntaxTriviaList
    include Enumerable(SyntaxTrivia)

    getter items : Array(SyntaxTrivia)

    def initialize(@items : Array(SyntaxTrivia) = [] of SyntaxTrivia)
    end

    def each(&block : SyntaxTrivia ->)
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
