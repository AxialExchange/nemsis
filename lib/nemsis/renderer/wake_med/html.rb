require 'ostruct'
module Nemsis
  module Renderer
    module WakeMed
      class HTML
        attr_accessor :parser 
       
        def initialize(nemsis_parser)
          raise ArgumentError.new('Rendered initiation requires a Parser instance passed in') if nemsis_parser.nil? or !nemsis_parser.is_a?(Nemsis::Parser)
          self.parser = nemsis_parser 
        end 

        # Set fancy_html to true to get a more colorful set of HTML results
        def render(fancy_html=false)
          @fancy_html = fancy_html
          erb_file = File.expand_path('../templates/runsheet.html.erb', __FILE__) 
          template = File.read(erb_file) 
          renderer = ERB.new(template)
          renderer.result(binding)
        end 
      end
    end
  end
end
