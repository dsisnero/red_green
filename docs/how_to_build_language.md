# How To Build A Language

This guide outlines a Roslyn-style workflow for creating a syntax model and
using red/green nodes in a parser.

## 1) Define syntax kinds

Pick a `SyntaxKind` enum for your language and map it to the `UInt16` kind
values stored on green nodes. Keep token kinds and node kinds in one place.

`RedGreen::SyntaxKindHelpers` provides helpers for converting between raw kinds
and typed enums.

## 2) Define the tree with ASDL

Author an ASDL file that describes your syntax nodes and their fields. Prefer
explicit fields so generated APIs remain stable.

## 3) Generate nodes

```bash
crystal run bin/asdl_codegen.cr -- --input path/to/lang.asdl --output src/generated/lang_nodes.cr
```

## 4) Create tokens and trivia

Tokens and trivia are green nodes:

```crystal
leading = [RedGreen::SyntaxFactory.trivia(1_u16, " ")]
token = RedGreen::SyntaxFactory.token(42_u16, "let", leading)
```

Tokens can be placed directly into green node slots.

## 5) Lex and parse

The library provides base classes for lexing and parsing:

- `RedGreen::Lexer` for tokenization
- `RedGreen::Parser` for building red/green trees

These are intentionally minimal so you can implement language-specific logic
using Crystal idioms.

## 6) Build a green tree

Use generated factories to build green nodes and attach tokens where needed.
Wrap the root in a `SyntaxTree`:

```crystal
tree = RedGreen::SyntaxTree.from_root(root.green, RedGreen::SourceText.from(source))
```

## 7) Walk the tree

Use `SyntaxWalker` to traverse nodes or tokens:

```crystal
walker = MyWalker.new
walker.visit_with_tokens(tree.root)
```
