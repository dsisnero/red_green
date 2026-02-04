module RedGreen
  # Immutable source text container.
  class SourceText
    getter text : String
    @line_starts : Array(Int32)?

    def initialize(@text : String)
      @line_starts = nil
    end

    def self.from(text : String) : SourceText
      new(text)
    end

    def length : Int32
      @text.bytesize
    end

    def to_s : String
      @text
    end

    def slice(span : TextSpan) : String
      start = span.start
      len = span.length
      return "" if len <= 0 || start >= @text.bytesize
      @text.byte_slice(start, len)
    end

    def line_count : Int32
      line_starts.size
    end

    def lines : Array(TextLine)
      result = [] of TextLine
      starts = line_starts
      index = 0
      while index < starts.size
        start_pos = starts[index]
        end_pos = index + 1 < starts.size ? starts[index + 1] : @text.bytesize
        length = end_pos - start_pos
        if length > 0 && @text.byte_at(end_pos - 1) == '\n'.ord
          length -= 1
        end
        result << TextLine.new(self, start_pos, length)
        index += 1
      end
      result
    end

    def line_at(index : Int32) : TextLine
      starts = line_starts
      raise "Line index out of range" if index < 0 || index >= starts.size
      start_pos = starts[index]
      end_pos = index + 1 < starts.size ? starts[index + 1] : @text.bytesize
      length = end_pos - start_pos
      if length > 0 && @text.byte_at(end_pos - 1) == '\n'.ord
        length -= 1
      end
      TextLine.new(self, start_pos, length)
    end

    def line_index(position : Int32) : Int32
      pos = position
      pos = 0 if pos < 0
      pos = @text.bytesize if pos > @text.bytesize
      starts = line_starts
      low = 0
      high = starts.size - 1
      while low <= high
        mid = (low + high) // 2
        start_pos = starts[mid]
        if start_pos == pos
          return mid
        elsif start_pos < pos
          low = mid + 1
        else
          high = mid - 1
        end
      end
      index = low - 1
      index < 0 ? 0 : index
    end

    def line_position(position : Int32) : LinePosition
      index = line_index(position)
      line = line_at(index)
      LinePosition.new(index, position - line.start)
    end

    def line_span(line_index : Int32) : TextSpan
      line_at(line_index).span
    end

    private def line_starts : Array(Int32)
      cached = @line_starts
      return cached if cached

      starts = [] of Int32
      starts << 0
      index = 0
      while index < @text.bytesize
        if @text.byte_at(index) == '\n'.ord
          next_pos = index + 1
          starts << next_pos if next_pos <= @text.bytesize
        end
        index += 1
      end
      @line_starts = starts
      starts
    end
  end
end
