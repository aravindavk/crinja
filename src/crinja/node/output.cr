module Crinja
  class Node
    abstract class Output
      abstract def value : String
    end

    class RenderedOutput < Output
      getter value

      def initialize(@value : String)
      end
    end

    class BlockOutput < Output
      getter name : String
      @output : String?

      def initialize(@name)
      end

      def resolved?
        !@output.nil?
      end

      def resolve(string : String)
        @output = string
      end

      def value : String
        raise "block placeholder not resolved #{name}" unless resolved?

        @output.not_nil!
      end
    end

    class OutputList < Output
      property nodes : Array(Output) = [] of Output
      property blocks : Array(BlockOutput) = [] of BlockOutput

      def <<(output)
        nodes << output

        blocks << output if output.is_a?(BlockOutput)
      end

      def value : String
        String.build do |io|
          value(io)
        end
      end

      def value(io : IO)
        nodes.each do |node|
          io << node.value
        end
      end
    end
  end
end
