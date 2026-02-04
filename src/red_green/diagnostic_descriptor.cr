module RedGreen
  # Metadata for a diagnostic.
  struct DiagnosticDescriptor
    getter id : String
    getter title : String
    getter message_format : String
    getter severity : DiagnosticSeverity

    def initialize(@id : String, @title : String, @message_format : String, @severity : DiagnosticSeverity)
    end
  end
end
