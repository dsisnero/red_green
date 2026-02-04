module RedGreen
  # Value wrapper around a green token.
  struct SyntaxToken
    getter green : InternalSyntax::GreenToken
    getter parent : SyntaxNode?
    getter position : Int32

    def initialize(@green : InternalSyntax::GreenToken, @parent : SyntaxNode?, @position : Int32)
    end

    def full_width : Int32
      @green.full_width
    end

    def kind : UInt16
      @green.kind
    end

    def kind_text : String
      @green.kind_text
    end

    def kind_as(enum_type : T.class) : T forall T
      enum_type.from_value(@green.kind.to_i)
    end

    def kind_as?(enum_type : T.class) : T? forall T
      enum_type.from_value?(@green.kind.to_i)
    end

    def kind?(kind : UInt16) : Bool
      @green.kind == kind
    end

    def kind?(kind : Enum) : Bool
      @green.kind == kind.to_u16
    end

    def missing? : Bool
      @green.flags.is_missing?
    end

    def text : String
      @green.text
    end

    def value_text : String
      @green.value_text
    end

    def raw_text : String
      @green.text
    end

    def text_kind : InternalSyntax::GreenToken::TextKind
      @green.text_kind
    end

    def leading_trivia : SyntaxTriviaList
      trivia = [] of SyntaxTrivia
      pos = @position
      @green.leading_trivia.each do |green_trivia|
        trivia << SyntaxTrivia.new(green_trivia, @parent, pos)
        pos += green_trivia.full_width
      end
      SyntaxTriviaList.new(trivia)
    end

    def trailing_trivia : SyntaxTriviaList
      trivia = [] of SyntaxTrivia
      pos = @position + leading_width + @green.text.bytesize
      @green.trailing_trivia.each do |green_trivia|
        trivia << SyntaxTrivia.new(green_trivia, @parent, pos)
        pos += green_trivia.full_width
      end
      SyntaxTriviaList.new(trivia)
    end

    def full_text : String
      String.build do |builder|
        @green.leading_trivia.each { |trivia| builder << trivia.text }
        builder << @green.text
        @green.trailing_trivia.each { |trivia| builder << trivia.text }
      end
    end

    def span : TextSpan
      TextSpan.new(@position + leading_width, @green.text.bytesize)
    end

    def full_span : TextSpan
      TextSpan.new(@position, @green.full_width)
    end

    def with_leading_trivia(trivia : Array(SyntaxTrivia)) : SyntaxToken
      green = InternalSyntax::GreenToken.new(@green.kind, @green.text, @green.value_text, @green.text_kind, trivia.map(&.green), @green.trailing_trivia, @green.flags)
      SyntaxToken.new(green, nil, 0)
    end

    def with_leading_trivia(trivia : SyntaxTriviaList) : SyntaxToken
      with_leading_trivia(trivia.items)
    end

    def with_trailing_trivia(trivia : Array(SyntaxTrivia)) : SyntaxToken
      green = InternalSyntax::GreenToken.new(@green.kind, @green.text, @green.value_text, @green.text_kind, @green.leading_trivia, trivia.map(&.green), @green.flags)
      SyntaxToken.new(green, nil, 0)
    end

    def with_trailing_trivia(trivia : SyntaxTriviaList) : SyntaxToken
      with_trailing_trivia(trivia.items)
    end

    def with_text(text : String) : SyntaxToken
      green = InternalSyntax::GreenToken.new(@green.kind, text, @green.value_text, @green.text_kind, @green.leading_trivia, @green.trailing_trivia, @green.flags)
      SyntaxToken.new(green, nil, 0)
    end

    def with_value_text(value_text : String) : SyntaxToken
      green = InternalSyntax::GreenToken.new(@green.kind, @green.text, value_text, @green.text_kind, @green.leading_trivia, @green.trailing_trivia, @green.flags)
      SyntaxToken.new(green, nil, 0)
    end

    def diagnostics : Array(Diagnostic)
      @green.diagnostics
    end

    private def leading_width : Int32
      width = 0
      @green.leading_trivia.each { |trivia| width += trivia.full_width }
      width
    end
  end
end
