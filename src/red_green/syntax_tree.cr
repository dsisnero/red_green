module RedGreen
  # Owns source text, diagnostics, and a root red node.
  class SyntaxTree
    getter root : SyntaxNode
    getter text : SourceText
    getter diagnostics : Array(Diagnostic)

    def initialize(@root : SyntaxNode, @text : SourceText, @diagnostics : Array(Diagnostic) = [] of Diagnostic)
    end

    def self.from_root(green_root : GreenNode, text : SourceText, diagnostics : Array(Diagnostic) = [] of Diagnostic) : SyntaxTree
      red_root = green_root.create_red(nil, 0)
      tree = SyntaxTree.new(red_root.as(SyntaxNode), text, diagnostics)
      tree.root.set_syntax_tree(tree)
      tree
    end

    def full_text : String
      @text.to_s
    end

    def with_text(text : SourceText) : SyntaxTree
      SyntaxTree.from_root(@root.green, text, @diagnostics)
    end

    def with_changed_text(text : String) : SyntaxTree
      with_text(SourceText.from(text))
    end
  end
end
