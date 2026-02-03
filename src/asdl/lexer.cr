module Asdl
  class Lexer
    def initialize(@source : String)
      @index = 0
      @line = 1
    end

    def next_token : Token?
      skip_whitespace_and_comments
      return nil if eof?

      start_line = @line
      if token = single_char_token(start_line)
        return token
      end

      char = current_char
      return lex_identifier(start_line) if letter?(char)
      raise SyntaxError.new("Illegal character: #{char}", start_line)
    end

    private def lex_identifier(start_line : Int32) : Token
      start = @index
      while !eof? && ident_char?(current_char)
        advance
      end
      value = @source[start...@index]

      if value[0].ascii_uppercase?
        Token.new(:CONSTRUCTID, value, start_line)
      else
        Token.new(:TYPEID, value, start_line)
      end
    end

    private def skip_whitespace_and_comments : Nil
      loop do
        while !eof? && whitespace?(current_char)
          advance
        end

        if !eof? && current_char == '-' && peek_char == '-'
          advance
          advance
          while !eof? && current_char != '\n'
            advance
          end
          next
        end

        break
      end
    end

    private def whitespace?(char : Char) : Bool
      if char == '\n'
        true
      else
        char == ' ' || char == '\t' || char == '\r'
      end
    end

    private def letter?(char : Char) : Bool
      char.ascii_letter?
    end

    private def ident_char?(char : Char) : Bool
      char.ascii_letter? || char.ascii_number? || char == '_'
    end

    private def eof? : Bool
      @index >= @source.bytesize
    end

    private def current_char : Char
      @source[@index]
    end

    private def peek_char : Char
      return '\0' if @index + 1 >= @source.bytesize
      @source[@index + 1]
    end

    private def advance : Nil
      if current_char == '\n'
        @line += 1
      end
      @index += 1
    end

    private def single_char_token(start_line : Int32) : Token?
      case current_char
      when '='
        advance
        Token.new(:EQUALS, "=", start_line)
      when ','
        advance
        Token.new(:COMMA, ",", start_line)
      when '?'
        advance
        Token.new(:QUESTION, "?", start_line)
      when '|'
        advance
        Token.new(:PIPE, "|", start_line)
      when '('
        advance
        Token.new(:LPAREN, "(", start_line)
      when ')'
        advance
        Token.new(:RPAREN, ")", start_line)
      when '*'
        advance
        Token.new(:ASTERISK, "*", start_line)
      when '{'
        advance
        Token.new(:LBRACE, "{", start_line)
      when '}'
        advance
        Token.new(:RBRACE, "}", start_line)
      else
        nil
      end
    end
  end
end
