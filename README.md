# red_green

Crystal port of Roslyn's red/green tree architecture for syntax trees.

## Status

This is an active porting effort. The core red/green infrastructure is usable
for experiments and internal tooling, but APIs are still evolving and are not
considered stable for long-term consumption yet.

## Installation

```bash
shards install
```

## Usage

Public APIs are not finalized yet. For now, use this repo as the
implementation home for the red/green tree core and supporting utilities.
See `docs/public_api.md` for the current public surface.
See `docs/performance.md` for benchmarking notes.
See `docs/asdl.md` for ASDL parsing and red/green codegen.
See `docs/overview.md` and `docs/architecture.md` for design context.
See `docs/getting_started.md` for a guided walkthrough.
See `docs/how_to_build_language.md` for end-to-end guidance.
See `docs/incremental_updates.md` and `docs/tree_editing.md` for workflows.
See `docs/changesets.md` for release note workflow.
See `docs/roadmap.md` for long-term goals.

## Development

```bash
crystal tool format src spec benchmarks
ameba --fix src spec benchmarks
ameba src spec benchmarks
crystal spec
```

## Contributing

1. Fork it (<https://github.com/dsisnero/red_green/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

* [dsisnero](https://github.com/dsisnero) - creator and maintainer
