module Asdl
  class Parser
    @lexer : Lexer?
    @cur_token : Token?

    def self.parse_file(path : String) : ModuleNode
      Parser.new.parse(File.read(path))
    end

    def initialize
      @lexer = nil
      @cur_token = nil
    end

    def parse(source : String) : ModuleNode
      @lexer = Lexer.new(source)
      advance
      parse_module
    end

    private def advance : String?
      value = @cur_token.try(&.value)
      lexer = @lexer
      raise SyntaxError.new("Lexer not initialized", 0) unless lexer
      @cur_token = lexer.next_token
      value
    end

    private def at_keyword(keyword : String) : Bool
      token = @cur_token
      return false unless token
      token.name == :TYPEID && token.value == keyword
    end

    private def parse_module : ModuleNode
      unless at_keyword("module")
        raise SyntaxError.new(%[Expected "module" (found #{token_value})], token_line)
      end
      advance

      name = match([:CONSTRUCTID, :TYPEID])
      match(:LBRACE)
      defs = parse_definitions
      match(:RBRACE)
      ModuleNode.new(name, defs)
    end

    private def parse_definitions : Array(TypeNode)
      defs = [] of TypeNode
      while (token = @cur_token) && token.name == :TYPEID
        typename = advance || raise SyntaxError.new("Expected type name", token_line)
        match(:EQUALS)
        type = parse_type
        defs << TypeNode.new(typename, type)
      end
      defs
    end

    private def parse_type : AstNode
      if (token = @cur_token) && token.name == :LPAREN
        return parse_product
      end

      sum_list = [ConstructorNode.new(match(:CONSTRUCTID), parse_optional_fields)]
      while (token = @cur_token) && token.name == :PIPE
        advance
        sum_list << ConstructorNode.new(match(:CONSTRUCTID), parse_optional_fields)
      end
      SumNode.new(sum_list, parse_optional_attributes)
    end

    private def parse_product : ProductNode
      ProductNode.new(parse_fields, parse_optional_attributes)
    end

    private def parse_fields : Array(FieldNode)
      fields = [] of FieldNode
      match(:LPAREN)
      while (token = @cur_token) && token.name == :TYPEID
        typename = advance || raise SyntaxError.new("Expected field type", token_line)
        is_seq, is_opt = parse_optional_field_quantifiers
        name = if (next_token = @cur_token) && id_kinds.includes?(next_token.name)
                 advance
               end
        fields << FieldNode.new(typename, name, is_seq, is_opt)

        if (next_token = @cur_token) && next_token.name == :RPAREN
          break
        elsif (next_token = @cur_token) && next_token.name == :COMMA
          advance
        end
      end
      match(:RPAREN)
      fields
    end

    private def parse_optional_fields : Array(FieldNode)
      return [] of FieldNode unless (token = @cur_token) && token.name == :LPAREN
      parse_fields
    end

    private def parse_optional_attributes : Array(FieldNode)
      return [] of FieldNode unless at_keyword("attributes")
      advance
      parse_fields
    end

    private def parse_optional_field_quantifiers : {Bool, Bool}
      is_seq = false
      is_opt = false

      if (token = @cur_token) && token.name == :ASTERISK
        is_seq = true
        advance
      elsif (token = @cur_token) && token.name == :QUESTION
        is_opt = true
        advance
      end

      {is_seq, is_opt}
    end

    private def id_kinds : Array(Symbol)
      [:CONSTRUCTID, :TYPEID]
    end

    private def match(kind : Symbol | Array(Symbol)) : String
      token = @cur_token
      raise SyntaxError.new("Unexpected EOF", 0) unless token

      if kind.is_a?(Array) ? kind.includes?(token.name) : token.name == kind
        value = token.value
        advance
        value
      else
        expected = kind.is_a?(Array) ? kind.join(", ") : kind
        raise SyntaxError.new("Unmatched #{expected} (found #{token.name})", token.line)
      end
    end

    private def token_value : String
      @cur_token.try(&.value) || ""
    end

    private def token_line : Int32
      @cur_token.try(&.line) || 0
    end
  end
end
