module RedGreen
  # Immutable, position-less syntax node (green tree).
  abstract class GreenNode
    SLOT_COUNT_MASK = 0x000F_u16
    FLAGS_SHIFT     =          4
    FLAGS_MASK      = 0xFFF0_u16

    getter kind : UInt16
    getter full_width : Int32
    @child_offsets : Array(Int32)?
    @diagnostics : Array(Diagnostic)?

    def initialize(@kind : UInt16, @flags_and_slot_count : UInt16, @full_width : Int32)
      @child_offsets = nil
      @diagnostics = nil
    end

    def slot_count : Int32
      (@flags_and_slot_count & SLOT_COUNT_MASK).to_i32
    end

    def flags_bits : UInt16
      (@flags_and_slot_count & FLAGS_MASK) >> FLAGS_SHIFT
    end

    def flags : NodeFlags
      NodeFlags.new(flags_bits)
    end

    def diagnostics : Array(Diagnostic)
      @diagnostics || [] of Diagnostic
    end

    protected def set_diagnostics(items : Array(Diagnostic)) : Nil
      @diagnostics = items
    end

    def self.pack_flags_and_slot_count(flags : NodeFlags, slot_count : Int32) : UInt16
      count = slot_count.to_u16 & SLOT_COUNT_MASK
      ((flags.to_u16 << FLAGS_SHIFT) & FLAGS_MASK) | count
    end

    abstract def language : String
    abstract def kind_text : String
    abstract def token? : Bool
    abstract def trivia? : Bool
    abstract def get_slot(index : Int32) : GreenNode?
    abstract def create_red(parent : SyntaxNode?, position : Int32) : SyntaxNode | SyntaxToken | SyntaxTrivia

    def get_child_position(slot : Int32) : Int32
      offsets = child_offsets
      return 0 if slot <= 0
      return offsets.last if slot >= offsets.size
      offsets[slot - 1]
    end

    def child_offsets : Array(Int32)
      cached = @child_offsets
      return cached if cached

      offsets = Array(Int32).new(slot_count, 0)
      position = 0
      index = 0
      while index < slot_count
        if child = get_slot(index)
          position += child.full_width
        end
        offsets[index] = position
        index += 1
      end
      @child_offsets = offsets
      offsets
    end
  end
end
