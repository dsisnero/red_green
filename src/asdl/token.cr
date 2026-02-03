module Asdl
  struct Token
    getter name : Symbol
    getter value : String
    getter line : Int32

    def initialize(@name : Symbol, @value : String, @line : Int32)
    end
  end
end
