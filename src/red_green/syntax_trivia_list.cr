module RedGreen
  # List wrapper for syntax trivia.
  struct SyntaxTriviaList
    include Enumerable(SyntaxTrivia)

    @@empty_items = [] of SyntaxTrivia

    getter items : Array(SyntaxTrivia)

    def initialize(@items : Array(SyntaxTrivia) = @@empty_items)
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

    def text : String
      String.build do |builder|
        @items.each { |trivia| builder << trivia.text }
      end
    end

    def full_text : String
      text
    end
  end
end
