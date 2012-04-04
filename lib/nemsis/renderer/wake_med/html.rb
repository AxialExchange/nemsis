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

        ###
        # This method will render the runsheet as an HTML file based on a template and spec YAML file
        # Set fancy_html to true to get a more colorful set of HTML results
        # Pass in a created_at date to help identify proper version (in case there are some issues with message send failures)
        def render(fancy_html=false, created_at=nil)
          @fancy_html = fancy_html
          @runsheet_created_at = created_at || Time.now
          erb_file = File.expand_path('../templates/runsheet.html.erb', __FILE__) 
          template = File.read(erb_file) 
          renderer = ERB.new(template)
          renderer.result(binding)
        end 
      end
    end
  end
end
class String
  ###
  # In the face of a blank string, return a space
  def space
    if self.empty?
      "&nbsp;"
    else
      self || super
    end
  end
end
