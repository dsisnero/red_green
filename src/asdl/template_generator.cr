module Asdl
  class TemplateGenerator < VisitorBase
    def initialize(@io : IO, @provider : TemplateProvider = DefaultTemplateProvider.new)
      super()
    end

    def visit_module(node : ModuleNode) : Nil
      @provider.render_module(@io, node)
    end

    def visit_type(node : TypeNode) : Nil
      @provider.render_type(@io, node)
    end
  end
end
