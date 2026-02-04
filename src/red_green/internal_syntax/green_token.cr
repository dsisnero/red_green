module RedGreen
  module InternalSyntax
    # Green token node with optional leading and trailing trivia.
    class GreenToken < GreenNode
      enum TextKind
        Plain
        Escaped
      end

      getter text : String
      getter value_text : String
      getter text_kind : TextKind
      getter leading_trivia : Array(GreenTrivia)
      getter trailing_trivia : Array(GreenTrivia)

      def initialize(
        @kind : UInt16,
        @text : String,
        @value_text : String = @text,
        @text_kind : TextKind = TextKind::Plain,
        @leading_trivia : Array(GreenTrivia) = [] of GreenTrivia,
        @trailing_trivia : Array(GreenTrivia) = [] of GreenTrivia,
        flags : NodeFlags = NodeFlags::None,
        diagnostics : Array(Diagnostic)? = nil,
      )
        if diagnostics && !diagnostics.empty?
          flags |= NodeFlags::ContainsDiagnostics
        end
        full_width = trivia_width(@leading_trivia) + @text.bytesize + trivia_width(@trailing_trivia)
        packed = GreenNode.pack_flags_and_slot_count(flags, 0)
        super(@kind, packed, full_width)
        set_diagnostics(diagnostics) if diagnostics
      end

      def language : String
        ""
      end

      def kind_text : String
        "Token"
      end

      def token? : Bool
        true
      end

      def trivia? : Bool
        false
      end

      def get_slot(index : Int32) : GreenNode?
        nil
      end

      def create_red(parent : SyntaxNode?, position : Int32) : SyntaxNode | SyntaxToken | SyntaxTrivia
        SyntaxToken.new(self, parent, position)
      end

      private def trivia_width(items : Array(GreenTrivia)) : Int32
        width = 0
        items.each { |trivia| width += trivia.full_width }
        width
      end
    end
  end
end
