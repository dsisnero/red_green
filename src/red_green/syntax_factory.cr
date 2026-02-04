module RedGreen
  # Convenience factory methods for common wrappers.
  module SyntaxFactory
    def self.list(nodes : Array(SyntaxNode)) : SyntaxList(SyntaxNode)
      SyntaxList(SyntaxNode).new(nodes)
    end

    def self.token_list(tokens : Array(SyntaxToken)) : SyntaxTokenList
      SyntaxTokenList.new(tokens)
    end

    def self.trivia_list(trivia : Array(SyntaxTrivia)) : SyntaxTriviaList
      SyntaxTriviaList.new(trivia)
    end

    def self.separated_list(nodes : Array(SyntaxNode), separators : Array(SyntaxToken)) : SeparatedSyntaxList(SyntaxNode)
      SeparatedSyntaxList(SyntaxNode).new(nodes, separators)
    end

    def self.trivia(
      kind : UInt16,
      text : String,
      diagnostics : Array(Diagnostic)? = nil,
    ) : InternalSyntax::GreenTrivia
      InternalSyntax::GreenTrivia.new(kind, text, NodeFlags::None, diagnostics)
    end

    def self.token(
      kind : UInt16,
      text : String,
      leading_trivia : Array(InternalSyntax::GreenTrivia) = [] of InternalSyntax::GreenTrivia,
      trailing_trivia : Array(InternalSyntax::GreenTrivia) = [] of InternalSyntax::GreenTrivia,
      diagnostics : Array(Diagnostic)? = nil,
    ) : SyntaxToken
      green = InternalSyntax::GreenToken.new(kind, text, text, InternalSyntax::GreenToken::TextKind::Plain, leading_trivia, trailing_trivia, NodeFlags::None, diagnostics)
      SyntaxToken.new(green, nil, 0)
    end

    def self.token(
      kind : UInt16,
      text : String,
      leading_trivia : Array(SyntaxTrivia),
      trailing_trivia : Array(SyntaxTrivia) = [] of SyntaxTrivia,
    ) : SyntaxToken
      green = InternalSyntax::GreenToken.new(kind, text, text, InternalSyntax::GreenToken::TextKind::Plain, leading_trivia.map(&.green), trailing_trivia.map(&.green))
      SyntaxToken.new(green, nil, 0)
    end

    def self.token(
      kind : UInt16,
      text : String,
      value_text : String,
      text_kind : InternalSyntax::GreenToken::TextKind = InternalSyntax::GreenToken::TextKind::Plain,
      leading_trivia : Array(InternalSyntax::GreenTrivia) = [] of InternalSyntax::GreenTrivia,
      trailing_trivia : Array(InternalSyntax::GreenTrivia) = [] of InternalSyntax::GreenTrivia,
    ) : SyntaxToken
      green = InternalSyntax::GreenToken.new(kind, text, value_text, text_kind, leading_trivia, trailing_trivia)
      SyntaxToken.new(green, nil, 0)
    end
  end
end
