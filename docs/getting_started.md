# Getting Started

This walkthrough shows the recommended flow for defining a language syntax
model and generating red/green node classes.

## 1) Define your ASDL

Create an ASDL file that describes your syntax tree. Keep it small at first,
and prefer explicit fields over generic containers.

## 2) Run the generator

Generate node classes and factories from your ASDL:

```bash
crystal run bin/asdl_codegen.cr -- --input path/to/your.asdl --output src/generated/your_nodes.cr
```

If you run into cache permission errors, set `CRYSTAL_CACHE_DIR` to a writable
directory inside the repo.

## 3) Use the generated factories

The generator emits factory methods that create green nodes and wrap them in
red nodes. These methods are the intended entry point when building trees.

For tokens and trivia, use `RedGreen::SyntaxFactory.token` and
`RedGreen::SyntaxFactory.trivia`. Tokens accept leading and trailing trivia,
which enables lossless text round-tripping.

## 4) Iterate and refine

Once you have nodes in place, you can:

- add parsing logic to build green nodes,
- extend templates to add visitors or helpers, and
- add diagnostics and incremental parsing support.

See `docs/asdl.md` for details on templates and generator customization.
