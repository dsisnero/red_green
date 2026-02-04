module RedGreen
  # Position-aware syntax node (red tree).
  abstract class SyntaxNode
    EMPTY_CHILDREN = [] of SyntaxNodeOrToken?

    getter parent : SyntaxNode?
    getter position : Int32
    getter green : GreenNode
    property syntax_tree : SyntaxTree?

    @children : Array(SyntaxNodeOrToken?)

    def initialize(
      @green : GreenNode,
      @parent : SyntaxNode?,
      @position : Int32,
      @syntax_tree : SyntaxTree? = nil,
    )
      slot_count = @green.slot_count
      @children = slot_count == 0 ? EMPTY_CHILDREN : Array(SyntaxNodeOrToken?).new(slot_count, nil)
    end

    protected def get_red_at(slot : Int32) : SyntaxNodeOrToken?
      return nil if slot < 0 || slot >= @children.size

      child = @children[slot]
      return child if child

      green_child = @green.get_slot(slot)
      return nil unless green_child

      created = green_child.create_red(self, child_position(slot))
      wrapped = case created
                when SyntaxTrivia
                  raise "Unexpected trivia node in green slot"
                else
                  SyntaxNodeOrToken.new(created)
                end
      @children[slot] = wrapped
      wrapped
    end

    protected def child_position(slot : Int32) : Int32
      @position + @green.get_child_position(slot)
    end

    def child_at(slot : Int32) : SyntaxNode?
      entry = get_red_at(slot)
      return nil unless entry
      return entry.as_node if entry.node?
      nil
    end

    def child_or_token_at(slot : Int32) : SyntaxNodeOrToken?
      get_red_at(slot)
    end

    def child_nodes : ChildSyntaxList
      ChildSyntaxList.new(self)
    end

    def children_with_tokens : ChildSyntaxListWithTokens
      ChildSyntaxListWithTokens.new(self)
    end

    def kind : UInt16
      @green.kind
    end

    def kind_text : String
      @green.kind_text
    end

    def kind_as(enum_type : T.class) : T forall T
      enum_type.from_value(@green.kind.to_i)
    end

    def kind_as?(enum_type : T.class) : T? forall T
      enum_type.from_value?(@green.kind.to_i)
    end

    def kind?(kind : UInt16) : Bool
      @green.kind == kind
    end

    def kind?(kind : Enum) : Bool
      @green.kind == kind.to_u16
    end

    def text : String
      String.build do |builder|
        children_with_tokens.each do |entry|
          builder << entry.text
        end
      end
    end

    def full_text : String
      String.build do |builder|
        children_with_tokens.each do |entry|
          builder << entry.full_text
        end
      end
    end

    def span : TextSpan
      TextSpan.new(@position, @green.full_width)
    end

    def full_span : TextSpan
      span
    end

    def ancestors : Array(SyntaxNode)
      nodes = [] of SyntaxNode
      current = @parent
      while current
        nodes << current
        current = current.parent
      end
      nodes
    end

    def descendants : Array(SyntaxNode)
      nodes = [] of SyntaxNode
      stack = [self] of SyntaxNode
      until stack.empty?
        current = stack.pop
        current.child_nodes.each do |child|
          nodes << child
          stack << child
        end
      end
      nodes
    end

    def next_sibling : SyntaxNode?
      return nil unless @parent
      index = slot_index
      return nil unless index
      slot = index + 1
      while slot < @parent.green.slot_count
        if child = @parent.child_at(slot)
          return child
        end
        slot += 1
      end
      nil
    end

    def prev_sibling : SyntaxNode?
      return nil unless @parent
      index = slot_index
      return nil unless index
      slot = index - 1
      while slot >= 0
        if child = @parent.child_at(slot)
          return child
        end
        slot -= 1
      end
      nil
    end

    def diagnostics : Array(Diagnostic)
      @green.diagnostics
    end

    def replace_child(old_child : SyntaxNode, new_child : SyntaxNode) : SyntaxNode
      raise "replace_child is not implemented for #{self.class}"
    end

    def replace_token(old_token : SyntaxToken, new_token : SyntaxToken) : SyntaxNode
      raise "replace_token is not implemented for #{self.class}"
    end

    def insert_child(index : Int32, child : SyntaxNode) : SyntaxNode
      raise "insert_child is not implemented for #{self.class}"
    end

    def remove_child(child : SyntaxNode) : SyntaxNode
      raise "remove_child is not implemented for #{self.class}"
    end

    def replace_node(old_node : SyntaxNode, new_node : SyntaxNode) : SyntaxNode
      if same?(old_node)
        return new_node
      end
      replace_child(old_node, new_node)
    end

    def replace_tokens(& : SyntaxToken -> SyntaxToken) : SyntaxNode
      raise "replace_tokens is not implemented for #{self.class}"
    end

    def replace_nodes(old_nodes : Array(SyntaxNode), new_nodes : Array(SyntaxNode)) : SyntaxNode
      raise "replace_nodes is not implemented for #{self.class}"
    end

    def insert_nodes_before(anchor : SyntaxNode, new_nodes : Array(SyntaxNode)) : SyntaxNode
      raise "insert_nodes_before is not implemented for #{self.class}"
    end

    def insert_nodes_after(anchor : SyntaxNode, new_nodes : Array(SyntaxNode)) : SyntaxNode
      raise "insert_nodes_after is not implemented for #{self.class}"
    end

    def remove_nodes(nodes : Array(SyntaxNode)) : SyntaxNode
      raise "remove_nodes is not implemented for #{self.class}"
    end

    protected def set_syntax_tree(tree : SyntaxTree) : Nil
      @syntax_tree = tree
    end

    private def slot_index : Int32?
      return nil unless @parent
      slot = 0
      while slot < @parent.green.slot_count
        node = @parent.child_at(slot)
        return slot if node && node.same?(self)
        slot += 1
      end
      nil
    end
  end
end
