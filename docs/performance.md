# Performance Notes

Use the benchmark harness for profiling:

```bash
crystal run benchmarks/benchmark.cr --release
```

Tune performance by iterating on hot paths discovered in benchmarks and
adjusting cache strategies (for example, `SyntaxNodeCache.strategy` and
`SyntaxNodeCache.strong_max_size`).
