module RedGreen
  # Base lexer interface for language-specific tokenization.
  abstract class Lexer
    getter text : SourceText
    getter diagnostics : DiagnosticBag

    def initialize(@text : SourceText)
      @diagnostics = DiagnosticBag.new
      @cursor = TextCursor.new(@text.text)
    end

    abstract def next_token : SyntaxToken

    def lex_all : Array(SyntaxToken)
      tokens = [] of SyntaxToken
      loop do
        token = next_token
        tokens << token
        break if token.kind == 0_u16
      end
      tokens
    end

    protected def cursor : TextCursor
      @cursor
    end

    @cursor : TextCursor
  end
end
