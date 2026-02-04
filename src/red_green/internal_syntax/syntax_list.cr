module RedGreen
  module InternalSyntax
    # Green list node holding an ordered set of green children.
    class SyntaxList < GreenNode
      getter children : Array(GreenNode)

      def initialize(@children : Array(GreenNode))
        flags = NodeFlags::None
        full_width = 0
        @children.each do |child|
          flags |= child.flags
          full_width += child.full_width
        end

        packed = GreenNode.pack_flags_and_slot_count(flags, @children.size)
        super(0_u16, packed, full_width)
      end

      def language : String
        ""
      end

      def kind_text : String
        "List"
      end

      def token? : Bool
        false
      end

      def trivia? : Bool
        false
      end

      def get_slot(index : Int32) : GreenNode?
        return nil if index < 0 || index >= @children.size
        @children[index]
      end

      def create_red(parent : SyntaxNode?, position : Int32) : SyntaxNode | SyntaxToken | SyntaxTrivia
        SyntaxListNode.new(self, parent, position, parent.try(&.syntax_tree))
      end
    end
  end

  # Red node wrapper for green list nodes.
  class SyntaxListNode < SyntaxNode
    def replace_child(old_child : SyntaxNode, new_child : SyntaxNode) : SyntaxListNode
      replace_child(old_child.as(SyntaxNode | SyntaxToken), new_child.as(SyntaxNode | SyntaxToken))
    end

    def replace_token(old_token : SyntaxToken, new_token : SyntaxToken) : SyntaxListNode
      replace_child(old_token.as(SyntaxNode | SyntaxToken), new_token.as(SyntaxNode | SyntaxToken))
    end

    def insert_child(index : Int32, child : SyntaxNode) : SyntaxListNode
      insert_child(index, child.as(SyntaxNode | SyntaxToken))
    end

    def remove_child(child : SyntaxNode) : SyntaxListNode
      remove_child_at(find_child_index(child.as(SyntaxNode | SyntaxToken)))
    end

    def replace_child(old_child : SyntaxNode | SyntaxToken, new_child : SyntaxNode | SyntaxToken) : SyntaxListNode
      replace_child_at(find_child_index(old_child), new_child)
    end

    def replace_child_at(index : Int32, new_child : SyntaxNode | SyntaxToken) : SyntaxListNode
      raise "Child index out of range" if index < 0
      children = green_children
      raise "Child index out of range" if index >= children.size
      children[index] = to_green(new_child)
      rebuild(children)
    end

    def insert_child(index : Int32, child : SyntaxNode | SyntaxToken) : SyntaxListNode
      children = green_children
      idx = index
      idx = 0 if idx < 0
      idx = children.size if idx > children.size
      children.insert(idx, to_green(child))
      rebuild(children)
    end

    def remove_child_at(index : Int32) : SyntaxListNode
      children = green_children
      raise "Child index out of range" if index < 0 || index >= children.size
      children.delete_at(index)
      rebuild(children)
    end

    def replace_tokens(& : SyntaxToken -> SyntaxToken) : SyntaxListNode
      children = green_children
      updated = false
      children.each_with_index do |child, idx|
        next unless child.is_a?(InternalSyntax::GreenToken)
        token = SyntaxToken.new(child, self, child_position(idx))
        new_token = yield token
        if new_token.green != child
          children[idx] = new_token.green
          updated = true
        end
      end
      return self unless updated
      rebuild(children)
    end

    def replace_nodes(old_nodes : Array(SyntaxNode), new_nodes : Array(SyntaxNode)) : SyntaxListNode
      raise "Node lists must be the same size" unless old_nodes.size == new_nodes.size
      mapping = Hash(GreenNode, GreenNode).new
      old_nodes.each_with_index do |node, idx|
        mapping[node.green] = new_nodes[idx].green
      end

      children = green_children
      updated = false
      children.each_with_index do |child, idx|
        replacement = mapping[child]?
        next unless replacement
        children[idx] = replacement
        updated = true
      end
      return self unless updated
      rebuild(children)
    end

    def insert_nodes_before(anchor : SyntaxNode, new_nodes : Array(SyntaxNode)) : SyntaxListNode
      insert_nodes_at(find_child_index(anchor.as(SyntaxNode | SyntaxToken)), new_nodes)
    end

    def insert_nodes_after(anchor : SyntaxNode, new_nodes : Array(SyntaxNode)) : SyntaxListNode
      insert_nodes_at(find_child_index(anchor.as(SyntaxNode | SyntaxToken)) + 1, new_nodes)
    end

    def remove_nodes(nodes : Array(SyntaxNode)) : SyntaxListNode
      return self if nodes.empty?
      removal = nodes.map(&.green).to_set
      children = green_children
      children.reject! { |child| removal.includes?(child) }
      rebuild(children)
    end

    private def insert_nodes_at(index : Int32, new_nodes : Array(SyntaxNode)) : SyntaxListNode
      return self if new_nodes.empty?
      children = green_children
      idx = index
      idx = 0 if idx < 0
      idx = children.size if idx > children.size
      nodes = new_nodes.map(&.green)
      children.insert(idx, *nodes)
      rebuild(children)
    end

    private def rebuild(children : Array(GreenNode)) : SyntaxListNode
      list = InternalSyntax::SyntaxList.new(children)
      list.create_red(@parent, @position).as(SyntaxListNode)
    end

    private def green_children : Array(GreenNode)
      @green.as(InternalSyntax::SyntaxList).children.dup
    end

    private def to_green(child : SyntaxNode | SyntaxToken) : GreenNode
      child.green
    end

    private def find_child_index(child : SyntaxNode | SyntaxToken) : Int32
      target = to_green(child)
      children = @green.as(InternalSyntax::SyntaxList).children
      index = 0
      while index < children.size
        return index if children[index].same?(target)
        index += 1
      end
      raise "Child not found in list"
    end
  end
end
