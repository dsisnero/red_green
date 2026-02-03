module Asdl
  class RedGreenGenerator
    BUILTIN_TYPES = {
      "identifier" => "String",
      "string"     => "String",
      "bytes"      => "String",
      "object"     => "String",
      "singleton"  => "Bool",
      "int"        => "Int32",
      "bool"       => "Bool",
    }

    def generate(mod : ModuleNode, module_name : String = mod.name) : String
      io = String::Builder.new
      io << "module " << module_name << "\n"
      mod.definitions.each do |type|
        emit_type(io, type)
      end
      emit_factory(io, mod)
      io << "end\n"
      io.to_s
    end

    private def emit_type(io : String::Builder, type : TypeNode) : Nil
      case value = type.value
      when SumNode
        value.types.each { |ctor| emit_constructor(io, ctor) }
      when ProductNode
        emit_product(io, type.name, value)
      end
    end

    private def emit_constructor(io : String::Builder, ctor : ConstructorNode) : Nil
      emit_product(io, ctor.name, ProductNode.new(ctor.fields))
    end

    private def emit_product(io : String::Builder, name : String, product : ProductNode) : Nil
      fields = product.fields
      node_fields = fields.select { |field| node_field?(field) }
      node_field_indices = node_fields.each_with_index.to_h
      io << "  class Green" << name << " < RedGreen::GreenNode\n"
      fields.each do |field|
        io << "    " << green_getter(field) << "\n"
      end
      io << "    def initialize(" << fields.map { |field| "#{field.name_or_type} : #{green_field_type(field)}" }.join(", ") << ")\n"
      io << "      " << fields.map { |field| "@#{field.name_or_type} = #{field.name_or_type}" }.join("\n      ") << "\n"
      io << "      flags = RedGreen::NodeFlags::None\n"
      io << "      full_width = 0\n"
      node_fields.each do |field|
        if field.seq?
          io << "      flags |= #{field.name_or_type}.flags\n"
          io << "      full_width += #{field.name_or_type}.full_width\n"
        elsif field.opt?
          io << "      if #{field.name_or_type}\n"
          io << "        flags |= #{field.name_or_type}.flags\n"
          io << "        full_width += #{field.name_or_type}.full_width\n"
          io << "      end\n"
        else
          io << "      flags |= #{field.name_or_type}.flags\n"
          io << "      full_width += #{field.name_or_type}.full_width\n"
        end
      end
      io << "      packed = RedGreen::GreenNode.pack_flags_and_slot_count(flags, #{node_fields.size})\n"
      io << "      super(0_u16, packed, full_width)\n"
      io << "    end\n"
      io << "    def language : String\n      \"\"\n    end\n"
      io << "    def kind_text : String\n      \"#{name}\"\n    end\n"
      io << "    def token? : Bool\n      false\n    end\n"
      io << "    def trivia? : Bool\n      false\n    end\n"
      io << "    def get_slot(index : Int32) : RedGreen::GreenNode?\n"
      io << "      case index\n"
      node_fields.each_with_index do |field, idx|
        io << "      when #{idx}\n        #{field.name_or_type}\n"
      end
      io << "      end\n"
      io << "    end\n"
      io << "    def create_red(parent : RedGreen::SyntaxNode?, position : Int32) : RedGreen::SyntaxNode\n"
      io << "      Red" << name << ".new(self, parent, position)\n"
      io << "    end\n"
      io << "  end\n"
      io << "  class Red" << name << " < RedGreen::SyntaxNode\n"
      io << "    def initialize(green : Green" << name << ", parent : RedGreen::SyntaxNode?, position : Int32)\n"
      io << "      super(green, parent, position)\n"
      io << "    end\n"
      fields.each do |field|
        if builtin?(field.type)
          io << "    " << red_accessor(field, name) << "\n"
        elsif field.seq?
          idx = node_field_indices[field]
          io << "    def " << field.name_or_type << " : RedGreen::ChildSyntaxList\n"
          io << "      list = @green.as(Green" << name << ")." << field.name_or_type << "\n"
          io << "      RedGreen::SyntaxListNode.new(list, self, child_position(#{idx})).child_nodes\n"
          io << "    end\n"
        else
          idx = node_field_indices[field]
          io << "    def " << field.name_or_type << " : RedGreen::SyntaxNode?\n"
          io << "      child_at(#{idx})\n"
          io << "    end\n"
        end
      end
      io << "  end\n"
    end

    private def emit_factory(io : String::Builder, mod : ModuleNode) : Nil
      io << "  module Factory\n"
      mod.definitions.each do |type|
        type.value.as(AstNode)
        emit_factory_type(io, type)
      end
      io << "  end\n"
    end

    private def emit_factory_type(io : String::Builder, type : TypeNode) : Nil
      case value = type.value
      when SumNode
        value.types.each { |ctor| emit_factory_ctor(io, ctor) }
      when ProductNode
        emit_factory_product(io, type.name, value.fields)
      end
    end

    private def emit_factory_ctor(io : String::Builder, ctor : ConstructorNode) : Nil
      emit_factory_product(io, ctor.name, ctor.fields)
    end

    private def emit_factory_product(io : String::Builder, name : String, fields : Array(FieldNode)) : Nil
      args = fields.map { |field| "#{field.name_or_type} : #{factory_arg_type(field)}" }.join(", ")
      io << "    def self.make_#{underscore(name)}(#{args}) : Red#{name}\n"
      io << "      green = Green#{name}.new(#{fields.map { |field| factory_to_green(field) }.join(", ")})\n"
      io << "      green.create_red(nil, 0).as(Red#{name})\n"
      io << "    end\n"
    end

    private def green_field_type(field : FieldNode) : String
      if builtin?(field.type)
        base = BUILTIN_TYPES[field.type]? || "String"
        return "Array(#{base})" if field.seq?
        return "#{base}?" if field.opt?
        return base
      end

      if field.seq?
        "RedGreen::InternalSyntax::SyntaxList"
      elsif field.opt?
        "RedGreen::GreenNode?"
      else
        "RedGreen::GreenNode"
      end
    end

    private def factory_arg_type(field : FieldNode) : String
      base = BUILTIN_TYPES[field.type]? || "RedGreen::SyntaxNode"
      if field.seq?
        "Array(#{base})"
      elsif field.opt?
        "#{base}?"
      else
        base
      end
    end

    private def builtin?(type : String) : Bool
      BUILTIN_TYPES.has_key?(type)
    end

    private def node_field?(field : FieldNode) : Bool
      !builtin?(field.type)
    end

    private def factory_to_green(field : FieldNode) : String
      if builtin?(field.type)
        field.name_or_type
      elsif field.seq?
        "RedGreen::InternalSyntax::SyntaxList.new(#{field.name_or_type}.map(&.green))"
      elsif field.opt?
        "#{field.name_or_type}.try(&.green)"
      else
        "#{field.name_or_type}.green"
      end
    end

    private def green_getter(field : FieldNode) : String
      name = field.name_or_type
      type = green_field_type(field)
      if bool_field?(field) && !field.seq? && !field.opt?
        "getter? #{name} : #{type}"
      else
        "getter #{name} : #{type}"
      end
    end

    private def red_accessor(field : FieldNode, name : String) : String
      field_name = field.name_or_type
      return_type = factory_arg_type(field)
      if bool_field?(field) && !field.seq? && !field.opt?
        "def #{field_name}? : #{return_type}\n      @green.as(Green#{name}).#{field_name}\n    end"
      else
        "def #{field_name} : #{return_type}\n      @green.as(Green#{name}).#{field_name}\n    end"
      end
    end

    private def bool_field?(field : FieldNode) : Bool
      field.type == "bool" || field.type == "singleton"
    end

    private def underscore(name : String) : String
      name.gsub(/([A-Z]+)/) { |match| "_#{match[0].downcase}" }.sub(/^_/, "")
    end
  end

  class FieldNode
    def name_or_type : String
      raw = name || type
      case raw
      when "annotation", "module", "class", "def", "end", "do", "if", "else", "elsif", "case", "when", "while", "until", "for", "break", "next", "return", "self"
        "#{raw}_"
      else
        raw
      end
    end
  end
end
