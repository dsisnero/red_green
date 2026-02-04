# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to
Semantic Versioning.

## [Unreleased]

- Initial project scaffolding.
- Red/green tree porting plan and tracking epics.
- Added architecture, overview, and getting started docs.
- Added changeset template and guidance.
- Added SourceText, TextSpan, and richer diagnostics.
- Added line mapping utilities (TextLine/LinePosition) and SyntaxTree text swapping helpers.
- Added DiagnosticDescriptor and Location for richer diagnostics metadata.
- Added token value_text and text kind support for normalized token text.
- Added base lexer/parser scaffolding and text cursor for parsing integration.
- Optimized token/trivia list wrappers to reuse shared empty arrays.
- Added roadmap doc for long-term workspace/semantic model goals.
- Added syntax kind helpers for typed enum conversions.
- Added green token/trivia internals and red token helpers.
- Added child enumeration with tokens and Roslyn-style traversal helpers.
