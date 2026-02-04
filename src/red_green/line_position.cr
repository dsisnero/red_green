module RedGreen
  # Line and character position in source text (0-based).
  struct LinePosition
    getter line : Int32
    getter character : Int32

    def initialize(@line : Int32, @character : Int32)
    end
  end
end
