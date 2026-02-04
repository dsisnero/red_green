module RedGreen
  # Helpers for converting raw kinds to typed enums.
  module SyntaxKindHelpers
    def self.raw(kind : Enum) : UInt16
      kind.to_i.to_u16
    end

    def self.from_raw(raw : UInt16, enum_type : T.class) : T forall T
      enum_type.from_value(raw.to_i)
    end

    def self.from_raw?(raw : UInt16, enum_type : T.class) : T? forall T
      enum_type.from_value?(raw.to_i)
    end
  end
end
