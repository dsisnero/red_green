module Asdl
  BUILTIN_TYPES = {"identifier", "string", "bytes", "int", "object", "singleton"}

  def self.builtin_type?(name : String) : Bool
    BUILTIN_TYPES.includes?(name)
  end

  class VisitorBase
    def visit(node : AstNode) : Nil
      case node
      when ModuleNode
        visit_module(node)
        node.definitions.each { |defn| visit(defn) }
      when TypeNode
        visit_type(node)
        visit(node.value)
      when SumNode
        visit_sum(node)
        node.types.each { |ctor| visit(ctor) }
      when ProductNode
        visit_product(node)
        node.fields.each { |field| visit(field) }
      when ConstructorNode
        visit_constructor(node)
        node.fields.each { |field| visit(field) }
      when FieldNode
        visit_field(node)
      end
    end

    def visit_module(node : ModuleNode) : Nil
    end

    def visit_type(node : TypeNode) : Nil
    end

    def visit_sum(node : SumNode) : Nil
    end

    def visit_product(node : ProductNode) : Nil
    end

    def visit_constructor(node : ConstructorNode) : Nil
    end

    def visit_field(node : FieldNode) : Nil
    end
  end

  class ChainOfVisitors
    def initialize(@visitors : Array(VisitorBase))
    end

    def visit(node : AstNode) : Nil
      @visitors.each do |visitor|
        visitor.visit(node)
      end
    end
  end
end
