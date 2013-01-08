require 'erb'

module Nemsis

  module Renderer

    module WakeMed

      module Helpers

        module TextHelper

          include ERB::Util

          # formats a text block as HTML using a simple set of rules:
          # * leading/railing whitespace removed
          # * HTML special characters escaped
          # * Trailing space chars on a line removed
          # * Leading space chars on a line converted to &nbsp;
          # * Newlines converted to <br>
          def simple_format(text)
            text = html_escape(text.to_s.strip)
            text.gsub!(/ +\n/, "\n")
            text.gsub!(/\n( +)/) {|s| "\n#{'&nbsp;' * (s.length - 1)}" }
            text.gsub!(/\n/, "<br>")
            text
          end

        end

      end

    end

  end

end
