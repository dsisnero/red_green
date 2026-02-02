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

      def create_red(parent : SyntaxNode?, position : Int32) : SyntaxNode
        SyntaxListNode.new(self, parent, position, parent.try(&.syntax_tree))
      end
    end
  end

  # Red node wrapper for green list nodes.
  class SyntaxListNode < SyntaxNode
  end
end
