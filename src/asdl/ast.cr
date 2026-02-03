module Asdl
  abstract class AstNode
  end

  class ModuleNode < AstNode
    getter name : String
    getter definitions : Array(TypeNode)
    getter types : Hash(String, AstNode)

    def initialize(@name : String, @definitions : Array(TypeNode))
      @types = @definitions.each_with_object({} of String => AstNode) do |type, memo|
        memo[type.name] = type.value
      end
    end
  end

  class TypeNode < AstNode
    getter name : String
    getter value : AstNode

    def initialize(@name : String, @value : AstNode)
    end
  end

  class ConstructorNode < AstNode
    getter name : String
    getter fields : Array(FieldNode)

    def initialize(@name : String, @fields : Array(FieldNode) = [] of FieldNode)
    end
  end

  class FieldNode < AstNode
    getter type : String
    getter name : String?
    getter? seq : Bool
    getter? opt : Bool

    def initialize(@type : String, @name : String? = nil, @seq : Bool = false, @opt : Bool = false)
    end
  end

  class SumNode < AstNode
    getter types : Array(ConstructorNode)
    getter attributes : Array(FieldNode)

    def initialize(@types : Array(ConstructorNode), @attributes : Array(FieldNode) = [] of FieldNode)
    end
  end

  class ProductNode < AstNode
    getter fields : Array(FieldNode)
    getter attributes : Array(FieldNode)

    def initialize(@fields : Array(FieldNode), @attributes : Array(FieldNode) = [] of FieldNode)
    end
  end
end
