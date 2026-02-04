module RedGreen
  # List wrapper for syntax tokens.
  struct SyntaxTokenList
    include Enumerable(SyntaxToken)

    @@empty_items = [] of SyntaxToken

    getter items : Array(SyntaxToken)

    def initialize(@items : Array(SyntaxToken) = @@empty_items)
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

    def text : String
      String.build do |builder|
        @items.each { |token| builder << token.text }
      end
    end

    def full_text : String
      String.build do |builder|
        @items.each { |token| builder << token.full_text }
      end
    end
  end
end
