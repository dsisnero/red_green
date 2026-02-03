require "./spec_helper"

# Prototype spec to lock down child position calculations.
module PositioningSpec
  class GreenNodeStub < RedGreen::GreenNode
    getter slot_widths : Array(Int32)

    def initialize(@slot_widths : Array(Int32))
      packed = RedGreen::GreenNode.pack_flags_and_slot_count(RedGreen::NodeFlags::None, @slot_widths.size)
      super(0_u16, packed, @slot_widths.sum)
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

    def get_child_position(slot : Int32) : Int32
      return 0 if slot <= 0
      @slot_widths[0, slot].sum
    end

    def create_red(parent : RedGreen::SyntaxNode?, position : Int32) : RedGreen::SyntaxNode
      RedGreen::SyntaxListNode.new(self, parent, position)
    end
  end
end

describe "RedGreen position calculations" do
  it "computes child positions from prior slot widths" do
    node = PositioningSpec::GreenNodeStub.new([1, 2, 0, 3])

    node.get_child_position(0).should eq(0)
    node.get_child_position(1).should eq(1)
    node.get_child_position(2).should eq(3)
    node.get_child_position(3).should eq(3)
    node.get_child_position(4).should eq(6)
  end

  it "uses total width as full width" do
    node = PositioningSpec::GreenNodeStub.new([2, 4, 1])
    node.full_width.should eq(7)
  end
end

describe "RedGreen basics" do
  it "packs flags and slot count" do
    packed = RedGreen::GreenNode.pack_flags_and_slot_count(RedGreen::NodeFlags::IsMissing, 3)
    packed.should eq(0x0043_u16)
  end

  it "enumerates child syntax list lazily" do
    green = PositioningSpec::GreenNodeStub.new([1, 2])
    list = RedGreen::ChildSyntaxList.new(RedGreen::SyntaxListNode.new(green, nil, 0))
    list.size.should eq(2)
  end

  it "handles syntax node cache strategy switch" do
    RedGreen::SyntaxNodeCache.strategy = RedGreen::SyntaxNodeCache::Strategy::Strong
    RedGreen::SyntaxNodeCache.get_or_add(1_u64) do
      PositioningSpec::GreenNodeStub.new([1]).as(RedGreen::GreenNode)
    end
    RedGreen::SyntaxNodeCache.try_get_node(1_u64).should_not be_nil
  ensure
    RedGreen::SyntaxNodeCache.strategy = RedGreen::SyntaxNodeCache::Strategy::Weak
  end
end
