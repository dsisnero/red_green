require "./spec_helper"

describe Asdl::Parser do
  it "parses a simple ASDL module" do
    source = <<-ASDL
    module test {
      expr = Name(identifier id)
           | Constant(int value)
    }
    ASDL

    mod = Asdl::Parser.new.parse(source)
    mod.name.should eq("test")
    mod.definitions.size.should eq(1)
    mod.definitions.first.name.should eq("expr")
  end
end

describe Asdl::RedGreenGenerator do
  it "generates red/green node stubs" do
    source = <<-ASDL
    module test {
      expr = Name(identifier id)
    }
    ASDL

    mod = Asdl::Parser.new.parse(source)
    code = Asdl::RedGreenGenerator.new.generate(mod, "TestLang")
    code.includes?("class GreenName").should be_true
    code.includes?("class RedName").should be_true
    code.includes?("module Factory").should be_true
  end
end
