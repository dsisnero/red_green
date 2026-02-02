require "./spec_helper"

# Prototype spec to lock down child position calculations.
module PositioningSpec
  class GreenNodeStub
    getter slot_widths : Array(Int32)

    def initialize(@slot_widths : Array(Int32))
    end

    def full_width : Int32
      @slot_widths.sum
    end

    def get_child_position(slot : Int32) : Int32
      return 0 if slot <= 0
      @slot_widths[0, slot].sum
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
