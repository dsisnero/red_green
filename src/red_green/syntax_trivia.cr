module RedGreen
  # Value wrapper around a green trivia node.
  struct SyntaxTrivia
    getter green : InternalSyntax::GreenTrivia
    getter parent : SyntaxNode?
    getter position : Int32

    def initialize(@green : InternalSyntax::GreenTrivia, @parent : SyntaxNode?, @position : Int32)
    end

    def full_width : Int32
      @green.full_width
    end

    def text : String
      @green.text
    end

    def kind : UInt16
      @green.kind
    end

    def kind_text : String
      @green.kind_text
    end

    def span : TextSpan
      TextSpan.new(@position, @green.full_width)
    end
  end
end
