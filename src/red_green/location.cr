module RedGreen
  # Represents a location in a source file.
  struct Location
    getter path : String?
    getter span : TextSpan

    def initialize(@span : TextSpan, @path : String? = nil)
    end

    def line_position(text : SourceText) : LinePosition
      text.line_position(@span.start)
    end
  end
end
