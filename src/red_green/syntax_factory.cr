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
  end
end
