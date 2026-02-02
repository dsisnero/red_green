module RedGreen
  # Enumerates the red children of a syntax node.
  struct ChildSyntaxList
    include Enumerable(SyntaxNode)

    getter parent : SyntaxNode
    getter children : Array(SyntaxNode)

    def initialize(@parent : SyntaxNode, @children : Array(SyntaxNode) = [] of SyntaxNode)
    end

    def each(&block : SyntaxNode ->)
      @children.each(&block)
    end

    def size : Int32
      @children.size
    end

    def empty? : Bool
      @children.empty?
    end
  end
end
