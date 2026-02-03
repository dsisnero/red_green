require "ecr"

module Asdl
  module TemplateProvider
    abstract def render_module(io : IO, mod : ModuleNode) : Nil
    abstract def render_type(io : IO, type : TypeNode) : Nil
  end

  class DefaultTemplateProvider
    include TemplateProvider

    TEMPLATE_ROOT = "#{__DIR__}/../../templates/asdl"

    def render_module(io : IO, mod : ModuleNode) : Nil
      ECR.render("#{TEMPLATE_ROOT}/module.ecr", io)
    end

    def render_type(io : IO, type : TypeNode) : Nil
      ECR.render("#{TEMPLATE_ROOT}/type.ecr", io)
    end
  end
end
