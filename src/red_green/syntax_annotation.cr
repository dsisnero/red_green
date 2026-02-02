module RedGreen
  # Attaches metadata to syntax nodes.
  class SyntaxAnnotation
    getter kind : String
    getter data : String?

    def initialize(@kind : String, @data : String? = nil)
    end
  end
end
