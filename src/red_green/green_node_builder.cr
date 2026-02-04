module RedGreen
  # Simple builder for green syntax list nodes.
  class GreenNodeBuilder
    def initialize
      @stack = Array(Array(GreenNode)).new
      @stack << [] of GreenNode
    end

    def start_list : Nil
      @stack << [] of GreenNode
    end

    def finish_list : InternalSyntax::SyntaxList
      raise "No open list to finish" if @stack.size <= 1
      children = @stack.pop
      list = InternalSyntax::SyntaxList.new(children)
      add_child(list)
      list
    end

    def add_child(node : GreenNode) : Nil
      @stack.last << node
    end

    def finish_root : InternalSyntax::SyntaxList
      raise "Nested lists still open" unless @stack.size == 1
      InternalSyntax::SyntaxList.new(@stack.pop)
    end
  end
end
