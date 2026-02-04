module RedGreen
  # Severity levels for diagnostics.
  enum DiagnosticSeverity
    Hidden
    Info
    Warning
    Error
  end

  # Represents a diagnostic message attached to syntax nodes.
  struct Diagnostic
    getter message : String
    getter id : String?
    getter descriptor : DiagnosticDescriptor?
    getter severity : DiagnosticSeverity
    getter span : TextSpan

    def initialize(@message : String, @severity : DiagnosticSeverity, @span : TextSpan, @id : String? = nil, @descriptor : DiagnosticDescriptor? = nil)
    end

    def position : Int32
      @span.start
    end

    def location(path : String? = nil) : Location
      Location.new(@span, path)
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
