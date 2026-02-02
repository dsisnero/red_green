module RedGreen
  module InternalSyntax
    class WithTwoChildren < SyntaxList
      def initialize(child0 : GreenNode, child1 : GreenNode)
        super([child0, child1])
      end
    end

    class WithThreeChildren < SyntaxList
      def initialize(child0 : GreenNode, child1 : GreenNode, child2 : GreenNode)
        super([child0, child1, child2])
      end
    end

    class WithManyChildren < SyntaxList
      def initialize(children : Array(GreenNode))
        super(children)
      end
    end

    class WithLotsOfChildren < SyntaxList
      def initialize(children : Array(GreenNode))
        super(children)
      end
    end
  end
end
