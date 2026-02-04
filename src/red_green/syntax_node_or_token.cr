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

    def text : String
      if token?
        as_token.text
      else
        as_node.text
      end
    end

    def full_text : String
      if token?
        as_token.full_text
      else
        as_node.full_text
      end
    end

    def kind : UInt16
      token? ? as_token.kind : as_node.kind
    end

    def kind_text : String
      token? ? as_token.kind_text : as_node.kind_text
    end

    def kind_as(enum_type : T.class) : T forall T
      token? ? as_token.kind_as(enum_type) : as_node.kind_as(enum_type)
    end

    def kind_as?(enum_type : T.class) : T? forall T
      token? ? as_token.kind_as?(enum_type) : as_node.kind_as?(enum_type)
    end

    def kind?(kind : UInt16) : Bool
      token? ? as_token.kind?(kind) : as_node.kind?(kind)
    end

    def kind?(kind : Enum) : Bool
      token? ? as_token.kind?(kind) : as_node.kind?(kind)
    end

    def full_width : Int32
      token? ? as_token.full_width : as_node.green.full_width
    end

    def span : TextSpan
      token? ? as_token.span : as_node.span
    end

    def full_span : TextSpan
      token? ? as_token.full_span : as_node.full_span
    end

    def diagnostics : Array(Diagnostic)
      token? ? as_token.diagnostics : as_node.diagnostics
    end

    def position : Int32
      token? ? as_token.position : as_node.position
    end
  end
end
