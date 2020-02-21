# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # @example
      #
      #   # bad
      #   let(:foo) { { baz: true } }
      #
      #   # good
      #   let(:foo) { Hash[baz: true] }
      class HashInBlockStyle < Cop
        include RuboCop::Cop::SurroundingSpace
        include RuboCop::Cop::RangeHelp

        MSG = "Please use Hash[] in inline block"

        def on_block(node)
          return unless %i[let let_it_be].include?(node.send_node.method_name)
          return unless inline_block?(node)

          hash = node.children.last
          return unless hash.is_a?(RuboCop::AST::HashNode)

          add_offense(hash, location: :expression)
        end

        def autocorrect(node)
          left = tokens(node).find(&:left_brace?)
          right = tokens(node).select(&:right_curly_brace?).last
          lambda do |corrector|
            corrector.replace(left.pos, 'Hash[')
            corrector.replace(right.pos, ']')
          end
        end

        private

        def inline_block?(node)
          tokens = processed_source.tokens
          end_index = index_of_last_token(node)
          tokens[end_index].right_curly_brace?
        end
      end
    end
  end
end
