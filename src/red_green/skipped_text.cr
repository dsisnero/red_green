module RedGreen
  # Placeholder for skipped text tokens/trivia during error recovery.
  struct SkippedText
    getter text : String

    def initialize(@text : String)
    end
  end
end
