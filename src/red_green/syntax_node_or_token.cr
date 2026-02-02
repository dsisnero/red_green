module RedGreen
  # Union wrapper for a syntax node or token.
  struct SyntaxNodeOrToken
    alias Value = SyntaxNode | SyntaxToken

    getter value : Value

    def initialize(@value : Value)
    end

    def node? : Bool
      @value.is_a?(SyntaxNode)
    end

    def token? : Bool
      @value.is_a?(SyntaxToken)
    end

    def as_node : SyntaxNode
      @value.as(SyntaxNode)
    end

    def as_token : SyntaxToken
      @value.as(SyntaxToken)
    end
  end
end
