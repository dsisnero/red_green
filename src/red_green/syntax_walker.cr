module RedGreen
  # Base visitor that walks a syntax tree depth-first.
  class SyntaxWalker
    def visit(node : SyntaxNode?) : Nil
      return unless node

      pre_visit(node)
      node.child_nodes.each { |child| visit(child) }
      post_visit(node)
    end

    protected def pre_visit(node : SyntaxNode) : Nil
    end

    protected def post_visit(node : SyntaxNode) : Nil
    end
  end
end
