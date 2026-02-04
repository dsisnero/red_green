module RedGreen
  # Represents a span in source text.
  struct TextSpan
    getter start : Int32
    getter length : Int32

    def initialize(@start : Int32, @length : Int32)
    end

    def self.from_bounds(start_pos : Int32, end_pos : Int32) : TextSpan
      length = end_pos - start_pos
      TextSpan.new(start_pos, length < 0 ? 0 : length)
    end

    def end_pos : Int32
      @start + @length
    end

    def contains?(position : Int32) : Bool
      position >= @start && position < end_pos
    end
  end
end
