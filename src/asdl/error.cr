module Asdl
  class SyntaxError < Exception
    getter line : Int32

    def initialize(message : String, @line : Int32)
      super("#{message} (found on line #{@line})")
    end
  end
end
