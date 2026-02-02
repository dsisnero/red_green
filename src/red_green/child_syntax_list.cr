module RedGreen
  # Enumerates the red children of a syntax node.
  struct ChildSyntaxList
    include Enumerable(SyntaxNode)

    getter parent : SyntaxNode

    def initialize(@parent : SyntaxNode)
    end

    def iterator : Iterator(SyntaxNode)
      ChildIterator.new(@parent)
    end

    def each(&block : SyntaxNode ->)
      iterator.each(&block)
    end

    def size : Int32
      @parent.green.slot_count
    end

    def empty? : Bool
      @parent.green.slot_count == 0
    end

    private class ChildIterator
      include Iterator(SyntaxNode)

      def initialize(@parent : SyntaxNode)
        @index = 0
      end

      def next
        while @index < @parent.green.slot_count
          node = @parent.child_at(@index)
          @index += 1
          return node if node
        end
        stop
      end

      def rewind
        @index = 0
        self
      end
    end
  end
end
