# Public API

This document summarizes the current public surface of `RedGreen`.

## Core Types

- `RedGreen::GreenNode` - Immutable, position-less syntax node.
- `RedGreen::SyntaxNode` - Position-aware wrapper around green nodes.
- `RedGreen::SyntaxTree` - Owns source text and diagnostics.
- `RedGreen::NodeFlags` - Flags packed into green nodes.
- `RedGreen::SourceText`
- `RedGreen::TextSpan`
- `RedGreen::TextLine`
- `RedGreen::LinePosition`
- `RedGreen::Diagnostic`, `RedGreen::DiagnosticSeverity`, `RedGreen::DiagnosticBag`
- `RedGreen::DiagnosticDescriptor`
- `RedGreen::Location`

## Tokens and Trivia

- `RedGreen::SyntaxToken`
- `RedGreen::SyntaxTrivia`
- `RedGreen::SyntaxTokenList`
- `RedGreen::SyntaxTriviaList`

## Lists and Navigation

- `RedGreen::SyntaxList(T)`
- `RedGreen::SeparatedSyntaxList(T)`
- `RedGreen::ChildSyntaxList`
- `RedGreen::ChildSyntaxListWithTokens`
- `RedGreen::SyntaxNodeOrToken`
- `RedGreen::SyntaxWalker`

## Infrastructure

- `RedGreen::SyntaxNodeCache`
- `RedGreen::SyntaxDiffer`
- `RedGreen::SyntaxFactory`
- `RedGreen::TextCursor`
- `RedGreen::Lexer`
- `RedGreen::Parser`
- `RedGreen::SyntaxKindHelpers`

## Advanced Placeholders

- `RedGreen::SyntaxAnnotation`
- `RedGreen::StructuredTrivia`
- `RedGreen::Directive`
- `RedGreen::SkippedText`
