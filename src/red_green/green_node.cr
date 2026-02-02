module RedGreen
  # Immutable, position-less syntax node (green tree).
  abstract class GreenNode
    SLOT_COUNT_MASK = 0x000F_u16
    FLAGS_SHIFT     =          4

    getter kind : UInt16
    getter full_width : Int32

    def initialize(@kind : UInt16, @flags_and_slot_count : UInt16, @full_width : Int32)
    end

    def slot_count : Int32
      (@flags_and_slot_count & SLOT_COUNT_MASK).to_i32
    end

    def flags_bits : UInt16
      (@flags_and_slot_count >> FLAGS_SHIFT).to_u16
    end

    abstract def language : String
    abstract def kind_text : String
    abstract def token? : Bool
    abstract def trivia? : Bool
    abstract def get_slot(index : Int32) : GreenNode?
    abstract def create_red(parent : SyntaxNode?, position : Int32) : SyntaxNode
  end
end
