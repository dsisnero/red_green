# Tree Editing

This library provides Roslyn-style editing helpers for list nodes. Editing
non-list nodes is expected to be done by rebuilding the node with generated
factory helpers.

## List editing

`SyntaxListNode` supports common operations:

- `replace_child`
- `insert_child`
- `remove_child`
- `replace_tokens`
- `replace_nodes`
- `insert_nodes_before`
- `insert_nodes_after`
- `remove_nodes`

These methods return a new list node with updated green children.

## Tokens and trivia

Tokens can be updated with `with_leading_trivia` and `with_trailing_trivia`.
`SyntaxToken#with_text` is available for token replacement without rebuilding
trivia.
`SyntaxToken#with_value_text` is available when you need to update normalized
token text.
Use `SyntaxFactory.token` and `SyntaxFactory.trivia` to construct new instances.
