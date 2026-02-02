module RedGreen
  # Flags describing green node characteristics.
  @[Flags]
  enum NodeFlags : UInt16
    None                     = 0_u16
    ContainsDiagnostics      = 1_u16
    ContainsAnnotations      = 2_u16
    IsMissing                = 4_u16
    ContainsStructuredTrivia = 8_u16
  end
end
