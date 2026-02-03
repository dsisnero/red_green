# red_green

Crystal port of Roslyn's red/green tree architecture for syntax trees.

## Status

This is an active porting effort. Expect APIs to evolve while the core
infrastructure and list utilities land.

## Installation

```bash
shards install
```

## Usage

Public APIs are not finalized yet. For now, use this repo as the
implementation home for the red/green tree core and supporting utilities.
See `docs/public_api.md` for the current public surface.
See `docs/performance.md` for benchmarking notes.

## Development

```bash
crystal tool format src spec
ameba --fix src spec
ameba src spec
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
