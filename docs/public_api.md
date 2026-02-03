# Public API

This document summarizes the current public surface of `RedGreen`.

## Core Types

- `RedGreen::GreenNode` - Immutable, position-less syntax node.
- `RedGreen::SyntaxNode` - Position-aware wrapper around green nodes.
- `RedGreen::SyntaxTree` - Placeholder for tree ownership.
- `RedGreen::NodeFlags` - Flags packed into green nodes.

## Tokens and Trivia

- `RedGreen::SyntaxToken`
- `RedGreen::SyntaxTrivia`
- `RedGreen::SyntaxTokenList`
- `RedGreen::SyntaxTriviaList`

## Lists and Navigation

- `RedGreen::SyntaxList(T)`
- `RedGreen::SeparatedSyntaxList(T)`
- `RedGreen::ChildSyntaxList`
- `RedGreen::SyntaxNodeOrToken`
- `RedGreen::SyntaxWalker`

## Infrastructure

- `RedGreen::SyntaxNodeCache`
- `RedGreen::SyntaxDiffer`
- `RedGreen::SyntaxFactory`

## Advanced Placeholders

- `RedGreen::SyntaxAnnotation`
- `RedGreen::Diagnostic`, `RedGreen::DiagnosticBag`
- `RedGreen::StructuredTrivia`
- `RedGreen::Directive`
- `RedGreen::SkippedText`
