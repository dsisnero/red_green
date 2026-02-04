module RedGreen
  # Base parser interface for language-specific syntax trees.
  abstract class Parser
    getter text : SourceText
    getter diagnostics : DiagnosticBag

    def initialize(@text : SourceText, @tokens : Array(SyntaxToken), @diagnostics : DiagnosticBag = DiagnosticBag.new)
    end

    abstract def parse_root : SyntaxNode

    def parse_tree : SyntaxTree
      root = parse_root
      SyntaxTree.new(root, @text, @diagnostics.items)
    end

    protected def tokens : Array(SyntaxToken)
      @tokens
    end

    @tokens : Array(SyntaxToken)
  end
end
