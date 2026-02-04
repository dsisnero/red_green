module RedGreen
  # Base visitor that walks a syntax tree depth-first.
  class SyntaxWalker
    def visit(node : SyntaxNode?) : Nil
      return unless node

      pre_visit(node)
      node.child_nodes.each { |child| visit(child) }
      post_visit(node)
    end

    def visit_with_tokens(node : SyntaxNode?) : Nil
      return unless node

      pre_visit(node)
      node.children_with_tokens.each do |entry|
        if entry.node?
          visit_with_tokens(entry.as_node)
        else
          visit_token(entry.as_token)
        end
      end
      post_visit(node)
    end

    protected def pre_visit(node : SyntaxNode) : Nil
    end

    protected def post_visit(node : SyntaxNode) : Nil
    end

    protected def visit_token(token : SyntaxToken) : Nil
    end
  end
end
