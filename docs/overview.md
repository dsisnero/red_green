# Overview

red_green is a Crystal port of Roslyn's red/green tree architecture. It provides
the core building blocks for lossless syntax trees while keeping fast parent/child
navigation and efficient incremental updates.

## Goals

- Lossless trees (trivia preserved)
- Cheap, position-aware navigation
- Efficient structural reuse
- Clear separation between immutable green nodes and red wrappers

## Core Concepts

### Green nodes

Green nodes are immutable, position-less tree nodes. They are lightweight and
can be shared. A green node knows its kind, flags, full width, and how to access
its children.

### Red nodes

Red nodes wrap green nodes and add parent pointers and positions. They are created
on demand and cached per parent, which makes navigation cheap without embedding
parent pointers in green nodes.

### Tokens and trivia

Tokens and trivia are value wrappers around green nodes. They are intended to be
small and cheap to copy, and they expose convenience APIs such as `full_width`
and `missing?`.

Tokens can carry leading and trailing trivia. Both tokens and trivia provide
`text` and `full_text` helpers for lossless round-tripping.
Tokens also expose `value_text` for normalized text (such as unescaped strings).

### Source text and diagnostics

`SyntaxTree` owns the `SourceText` for a tree, along with any diagnostics
produced during parsing. Nodes and tokens can surface diagnostics when they
carry them.

### Lists

Lists are represented as green list nodes with red wrappers for list iteration.
This allows lists to participate in the same caching and slot-based child access
as any other node.

## Where this fits

red_green is not a full parser or compiler. It provides the data model that
language front-ends can build on. ASDL code generation is available to produce
node types and factories, but parser integration is still a work in progress.
