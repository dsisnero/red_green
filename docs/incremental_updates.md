# Incremental Updates

Incremental parsing hinges on structural reuse. The red/green model supports
this by keeping green nodes immutable and creating red wrappers on demand.

## Suggested workflow

1. Parse the new text into a new green tree.
2. Reuse unchanged green subtrees from the prior tree where possible.
3. Create a new `SyntaxTree` with the updated root.

`SyntaxTree#with_text` and `SyntaxTree#with_changed_text` provide a minimal
path for swapping source text when reusing green trees.

## Diagnostics

Attach diagnostics to green nodes or store them at the tree level, depending on
your parser pipeline. `SyntaxTree` exposes the diagnostic list for consumers.

Diagnostics can also surface `Location` metadata (span + optional path) and can
be enriched with `DiagnosticDescriptor` for IDs and message formats.
