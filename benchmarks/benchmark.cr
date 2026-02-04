require "../src/red_green"
require "benchmark"

def build_stub_nodes(count : Int32)
  nodes = [] of RedGreen::GreenNode
  count.times do
    nodes << PositioningSpec::GreenNodeStub.new([1, 2])
  end
  nodes
end

module PositioningSpec
  class GreenNodeStub < RedGreen::GreenNode
    def initialize(slot_widths : Array(Int32))
      packed = RedGreen::GreenNode.pack_flags_and_slot_count(RedGreen::NodeFlags::None, slot_widths.size)
      super(0_u16, packed, slot_widths.sum)
    end

    def language : String
      ""
    end

    def kind_text : String
      "Stub"
    end

    def token? : Bool
      false
    end

    def trivia? : Bool
      false
    end

    def get_slot(index : Int32) : RedGreen::GreenNode?
      nil
    end

    def create_red(parent : RedGreen::SyntaxNode?, position : Int32) : RedGreen::SyntaxNode | RedGreen::SyntaxToken | RedGreen::SyntaxTrivia
      RedGreen::SyntaxListNode.new(self, parent, position)
    end
  end
end

Benchmark.ips do |x|
  x.report("create green nodes") { build_stub_nodes(1000) }
  x.report("child offsets cached") do
    node = PositioningSpec::GreenNodeStub.new([1, 2, 3, 4, 5])
    1000.times { node.get_child_position(4) }
  end
  x.report("builder list") do
    builder = RedGreen::GreenNodeBuilder.new
    1000.times do
      builder.start_list
      builder.add_child(PositioningSpec::GreenNodeStub.new([1]))
      builder.add_child(PositioningSpec::GreenNodeStub.new([2]))
      builder.finish_list
    end
  end
end
