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

## CLI

Generate a Crystal file from an ASDL source:

```bash
crystal run bin/asdl_codegen.cr -- --input asdl/asdl_files/Python.asdl --output src/generated/python_nodes.cr
```

## Template Pipeline

You can also drive generation via a visitor pipeline with ECR templates:

```crystal
mod = Asdl::Parser.new.parse(source)
io = String::Builder.new
generator = Asdl::TemplateGenerator.new(io)
generator.visit(mod)
puts io.to_s
```

Override templates by providing your own `TemplateProvider` implementation and
pointing it at your own ECR files.
