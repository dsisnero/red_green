# Architecture

This document describes how the red/green tree model is represented in this
library and where the main extension points are.

## Green node model

- `RedGreen::GreenNode` is the base class for all green nodes.
- It stores kind, flags, and `full_width`.
- Children are accessed by slot index via `get_slot`.
- Child position offsets are cached per node to keep navigation fast.

## Red node model

- `RedGreen::SyntaxNode` wraps a green node, a parent, and a position.
- Red children are created lazily and cached in a slot-aligned array.
- The red wrapper is responsible for navigation APIs such as `child_at`.

## Tokens and trivia

- `RedGreen::SyntaxToken` and `RedGreen::SyntaxTrivia` are value wrappers.
- They forward most behavior to the underlying green node.
- `InternalSyntax::GreenToken` stores the token text and its trivia.
- `InternalSyntax::GreenTrivia` stores raw trivia text.

## Lists

- Green lists live under `RedGreen::InternalSyntax::SyntaxList`.
- Red list wrappers (`SyntaxList`, `SeparatedSyntaxList`, `ChildSyntaxList`)
  provide typed access and iteration without allocating additional nodes.

## Caching

- `RedGreen::SyntaxNodeCache` provides optional green node caching.
- Strategy can be `Weak` or `Strong`, depending on workload and memory budget.

## Source text and diagnostics

- `RedGreen::SourceText` stores the original text.
- `RedGreen::SyntaxTree` owns the text, root node, and diagnostics.

## Code generation

The ASDL toolchain generates:

- Green node classes
- Red node wrappers
- Factory helpers

Templates are defined in `templates/asdl` and can be overridden by the user.
