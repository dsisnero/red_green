module RedGreen
  # Position-aware syntax node (red tree).
  abstract class SyntaxNode
    getter parent : SyntaxNode?
    getter position : Int32
    getter green : GreenNode
    getter syntax_tree : SyntaxTree?

    @children : Array(SyntaxNode?)

    def initialize(
      @green : GreenNode,
      @parent : SyntaxNode?,
      @position : Int32,
      @syntax_tree : SyntaxTree? = nil,
    )
      @children = Array(SyntaxNode?).new(@green.slot_count, nil)
    end

    protected def get_red_at(slot : Int32) : SyntaxNode?
      return nil if slot < 0 || slot >= @children.size

      child = @children[slot]
      return child if child

      green_child = @green.get_slot(slot)
      return nil unless green_child

      child = green_child.create_red(self, child_position(slot)).as(SyntaxNode)
      @children[slot] = child
      child
    end

    protected def child_position(slot : Int32) : Int32
      @position + @green.get_child_position(slot)
    end
  end
end
