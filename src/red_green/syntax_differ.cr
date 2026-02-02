module RedGreen
  # Minimal syntax tree comparison utility.
  class SyntaxDiffer
    def self.same?(left : SyntaxNode?, right : SyntaxNode?) : Bool
      return true if left.nil? && right.nil?
      return false if left.nil? || right.nil?
      left.green == right.green
    end
  end
end
