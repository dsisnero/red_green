module RedGreen
  # Represents a diagnostic message attached to syntax nodes.
  struct Diagnostic
    getter message : String
    getter position : Int32

    def initialize(@message : String, @position : Int32)
    end
  end

  # Simple container for diagnostics.
  class DiagnosticBag
    getter items : Array(Diagnostic)

    def initialize(@items : Array(Diagnostic) = [] of Diagnostic)
    end

    def add(diagnostic : Diagnostic) : Nil
      @items << diagnostic
    end

    def any? : Bool
      !@items.empty?
    end
  end
end
