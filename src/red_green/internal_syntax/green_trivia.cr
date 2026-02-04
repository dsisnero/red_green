module RedGreen
  module InternalSyntax
    # Green trivia node holding raw text.
    class GreenTrivia < GreenNode
      getter text : String

      def initialize(
        @kind : UInt16,
        @text : String,
        flags : NodeFlags = NodeFlags::None,
        diagnostics : Array(Diagnostic)? = nil,
      )
        if diagnostics && !diagnostics.empty?
          flags |= NodeFlags::ContainsDiagnostics
        end
        packed = GreenNode.pack_flags_and_slot_count(flags, 0)
        super(@kind, packed, @text.bytesize)
        set_diagnostics(diagnostics) if diagnostics
      end

      def language : String
        ""
      end

      def kind_text : String
        "Trivia"
      end

      def token? : Bool
        false
      end

      def trivia? : Bool
        true
      end

      def get_slot(index : Int32) : GreenNode?
        nil
      end

      def create_red(parent : SyntaxNode?, position : Int32) : SyntaxNode | SyntaxToken | SyntaxTrivia
        SyntaxTrivia.new(self, parent, position)
      end
    end
  end
end
