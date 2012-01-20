module Nemsis
  module Renderer
    module WakeMed
      class HTML
        attr_accessor :parser 
       
        def initialize(nemsis_parser) 
          self.parser = nemsis_parser 
        end 
       
        def render 
          erb_file = File.expand_path('../templates/runsheet.html.erb', __FILE__) 
          template = File.read(erb_file) 
          renderer = ERB.new(File.read(erb_file)) 
          renderer.result(binding) 
        end 
      end
    end
  end
end
