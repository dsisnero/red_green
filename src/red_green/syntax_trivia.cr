module RedGreen
  # Value wrapper around a green trivia node.
  struct SyntaxTrivia
    getter green : GreenNode
    getter parent : SyntaxNode?
    getter position : Int32

    def initialize(@green : GreenNode, @parent : SyntaxNode?, @position : Int32)
    end

    def full_width : Int32
      @green.full_width
    end
  end
end
