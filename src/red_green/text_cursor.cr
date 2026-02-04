module RedGreen
  # Byte-oriented cursor for lexing/parsing.
  class TextCursor
    getter text : String
    getter position : Int32

    def initialize(@text : String)
      @position = 0
    end

    def eof? : Bool
      @position >= @text.bytesize
    end

    def peek(offset : Int32 = 0) : UInt8?
      index = @position + offset
      return nil if index < 0 || index >= @text.bytesize
      @text.byte_at(index)
    end

    def advance : UInt8?
      return nil if eof?
      byte = @text.byte_at(@position)
      @position += 1
      byte
    end

    def advance_while(& : UInt8 -> Bool) : Int32
      start = @position
      while (byte = peek) && yield byte
        @position += 1
      end
      @position - start
    end

    def slice_from(start_pos : Int32, end_pos : Int32 = @position) : String
      length = end_pos - start_pos
      return "" if length <= 0
      @text.byte_slice(start_pos, length)
    end
  end
end
