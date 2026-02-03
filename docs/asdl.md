# ASDL Parser and Red/Green Codegen

Use the ASDL parser to read a grammar and generate Crystal red/green nodes.

```crystal
source = <<-ASDL
module test {
  expr = Name(identifier id)
       | Constant(int value)
}
ASDL

mod = Asdl::Parser.new.parse(source)
code = Asdl::RedGreenGenerator.new.generate(mod, "TestLang")
File.write("src/test_lang_nodes.cr", code)
```

The generated module includes:

- `Green*` nodes (green tree)
- `Red*` nodes (red tree)
- `Factory` helpers for ergonomic creation
