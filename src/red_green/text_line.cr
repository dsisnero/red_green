module RedGreen
  # Represents a single line in SourceText.
  struct TextLine
    getter text : SourceText
    getter start : Int32
    getter length : Int32

    def initialize(@text : SourceText, @start : Int32, @length : Int32)
    end

    def span : TextSpan
      TextSpan.new(@start, @length)
    end

    def end_pos : Int32
      @start + @length
    end

    def to_s : String
      @text.slice(span)
    end
  end
end
