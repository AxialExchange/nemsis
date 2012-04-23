require 'ostruct'
module Nemsis
  module Renderer
    module WakeMed
      class HTML
        HTML_STYLE = <<STYLE
    <HEAD>
      <STYLE type="text/css">
          <!--

              /*p, h4, table {font-family: "Lucida Grande", verdana, arial, helvetica, sans-serif;}*/
              /*p, h4, table {font-family: Tahoma, Geneva, sans-serif}*/
          p, h4, table {
              font-family: "Trebuchet MS", Helvetica, sans-serif
          }

          p {
              font-size: small;
          }

          H4 {
              color: black
          }

              /* Each section can be a table */
          table, tbody, tr {
              border: 1px;
              border-style: solid;
              border-color: black;
              border-spacing: 0px;
              width: 700;
              color: black;
              margin: 0;
              padding: 1px;
          }

              /* The section can have a bold heading row */
          th {
              color: yellow;
              background-color: #6495ed;
              font-size: medium;
              border-color: black;
              border-style: solid;
              border-width: 1px;
          }

              /* Default table cell for values */
          td {
              border: 1px;
              border-style: solid;
              border-color: #737373;
              font-size: small;
              padding: 2px;
          }

              /* Default label cell */
          td.label {
              text-align: left;
              font-weight: bold;
              background-color: #dcdcdc;
          }

              /* Label on top of column */
          td.label-top {
              text-align: center;
              font-weight: bold;
              background-color: #dcdcdc;
          }

              /* Narrow label cell */
          td.label-narrow {
              text-align: left;
              font-weight: bold;
              background-color: #dcdcdc;
              width: 10%;
          }

              /* Medium label cell */
          td.label-medium {
              text-align: left;
              font-weight: bold;
              background-color: #dcdcdc;
              width: 25%;
          }
          .no-border {
              border: 1px;
              border-style: none;
              border-color: red;
              border-spacing: 0px;
          }

          -->
      </STYLE>
    </HEAD>
STYLE
        #include Nemsis::Renderer::WakeMed::HtmlHelper
        attr_accessor :parser

        def initialize(nemsis_parser)
          raise ArgumentError.new('Rendered initiation requires a Parser instance passed in') if nemsis_parser.nil? or !nemsis_parser.is_a?(Nemsis::Parser)
          self.parser = nemsis_parser
        end

        ###
        # This method will render the runsheet as an HTML file based on a template and spec YAML file
        # Set fancy_html to true to get a more colorful set of HTML results
        # Pass in a created_at date to help identify proper version (in case there are some issues with message send failures)
        def render_fancy(created_at=nil)
          render_template(true, created_at)
        end
        def render(created_at=nil)
          render_template(false, created_at)
        end

        # ******************************************************************
        # Assorted HELPER methods for the HTML generation
        # ******************************************************************

        def runsheet_date
          case @runsheet_created_at.class
          when Time || ActiveSupportWithZone
            return @runsheet_created_at
          when String
            return ActiveSupport::TimeZone.new('UTC').parse(@runsheet_created_at)
          else 
            return ActiveSupport::TimeZone.new('UTC').parse(@runsheet_created_at.to_s)
          end
        end

        def runsheet_timestamp
          runsheet_date.in_time_zone('Eastern Time (US & Canada)').strftime("%Y-%m-%d %H:%M:%S %Z")
        end

        @fancy_html          ||= false
        @runsheet_created_at ||= Time.now

        def start_table(title="", colspan=2, options="")
          if @fancy_html
            text = "<table #{(options.empty?) ? '' : options} #{(title.empty?) ? '' : "title='#{title}'"}>"
          else
            text = "<table border='1' cellspacing='0' width='700' #{(title.empty?) ? '' : "title='#{title}'"}>"
          end
          text += '<thead>'
          text += start_row
          text += heading(title, colspan) unless title.empty?
          text += '</tr>'
          text += '</thead>'
        end

        def borderless_table
          if @fancy_html
            text = "<table class='no-border'>"
          else
            text = "<table border='0' cellspacing='0' width='700'>"
          end
        end

        def borderless_cell(label, value)
          if @fancy_html
            text = "<td class='no-border'><b>#{label}</b></td><td class='no-border'>#{value}</td>"
          else
            text = "<td border='0'><font size='2'><b>#{label}</b></font><td border='0'><font size='2'>#{value}</font></td>"
          end
        end

        # Create a grid of Label/Value pairs using the name from the YML file as the label
        # fields can be empty, an element name, or a hash {label => field}
        # Optionally, the last value can be a colspan
        #     row( {"Expired" => "concat('E29_14', 'E29_15', 'E29_16')"}, 3)
        def row(*fields)
          raise ArgumentError.new("you must pass fields into row() method!") if fields.nil?
          colspan = 0
          colspan = fields.last if fields.last.is_a?(Fixnum)
          text = start_row
          num_columns = fields.size rescue 0
          fields.each do |field|
            next if field.is_a?(Fixnum)
            #puts "Field = #{field}"
            if field.empty?
              text += cell(" ")
              text += cell(" ")
            elsif field.is_a?(Hash)
              label = field.keys[0]
              value = field[label]
              if num_columns < 3
                text += labeled_cell_medium(label, (value.empty? ? '' : @parser.send(value)), colspan)
              elsif num_columns > 3
                text += labeled_cell_narrow(label, (value.empty? ? '' : @parser.send(value)), colspan)
              else
                text += labeled_cell(label, (value.empty? ? '' : @parser.send(value)), colspan)
              end
            else
              element = @parser.get(field)
              text    += labeled_cell(element[:name], @parser.send(field), colspan)
            end
          end
          text += '</tr>'
        end

        # Specialized row version for the Obstetrical table
        def ob_row(field1, field2, field3, field4)
          text    = start_row
          element = @parser.get(field1)
          text    += labeled_cell(element[:name], @parser.send(field1))
          if field2.empty?
            text += cell("")
            text += cell("")
          else
            element = @parser.get(field2)
            text    += labeled_cell(element[:name], @parser.send(field2))
          end
          element = @parser.get(field3)
          text    += labeled_cell(element[:name], @parser.index(field3))
          element = @parser.get(field4)
          text    += cell @parser.index(field4)

          text += '</tr>'
        end

        def start_row(options="")
          if @fancy_html
            text = "<tr#{(options.empty?) ? '' : " #{options}"}>"
          else
            text = "<tr>"
          end
        end

        def label(label, colspan=0)
          label = label.space unless label.nil?
          if @fancy_html
            text = "    <td class='label' #{(colspan > 0) ? "colspan='#{colspan}'" : '' } >#{label}</td>"
          else
            text = "    <td#{(colspan > 0) ? " colspan='#{colspan}'" : '' }><font size='2'><b>#{label}</b></font></td>"
          end
          text
        end

        def label_with_style(style, label, rowspan=0)
          label = label.space unless label.nil?
          if @fancy_html
            text = "<td class='#{style}' #{(rowspan > 0) ? "rowspan='#{rowspan}'" : '' }>#{label}</td>"
          else
            text = case style
                     when 'label'
                       "<td#{(rowspan > 0) ? " rowspan='#{rowspan}'" : '' }><font size='2'><b>#{label}</b></font></td>"
                     when 'label-medium'
                       "<td width='25%'#{(rowspan > 0) ? " rowspan='#{rowspan}'" : '' }><font size='2'><b>#{label}</b></font></td>"
                     when 'label-narrow'
                       "<td width='10%'#{(rowspan > 0) ? " rowspan='#{rowspan}'" : '' }><font size='2'><b>#{label}</b></font></td>"
                     else
                       "<td#{(rowspan > 0) ? " rowspan='#{rowspan}'" : '' }><font size='2'><b>#{label}</b></font></td>"
                   end
            text
          end
        end

        def tall_label(label, rowspan=0)
          label = label.space unless label.nil?
          label_with_style('label', label, rowspan)
        end

        def label_top(label, colspan=0)
          label = label.space unless label.nil?
          if @fancy_html
            text = "    <td class='label-top' #{(colspan > 0) ? "colspan='#{colspan}'" : '' }>#{label}</td>"
          else
            text = "    <td#{(colspan > 0) ? " colspan='#{colspan}'" : '' }><font size='2'><b>#{label}</b></font></td>"
          end
          text
        end

        def heading(label, colspan=0)
          label = label.space unless label.nil?
          if @fancy_html
            text = "    <th#{(colspan > 0) ? " colspan='#{colspan}'" : '' }>#{label}</th>"
          else
            text = "    <th#{(colspan > 0) ? " colspan='#{colspan}'" : '' }><font color='blue' size='3'>#{label}</font></th>"
          end
          text
        end

        def cell(value, colspan=0, rowspan=0)
          value = value.space if value.is_a?(String)
          if @fancy_html
            text = "    <td class='value'#{(colspan > 0) ? " colspan='#{colspan}'" : '' }#{(rowspan > 0) ? " rowspan='#{rowspan}'" : '' }>#{value}</td>"
          else
            text = "    <td #{(colspan > 0) ? " colspan='#{colspan}'" : '' }#{(rowspan > 0) ? " rowspan='#{rowspan}'" : '' }><font size='2'>#{value}</font></td>"
          end
          text
        end

        def labeled_cell_with_style(style, label, value, colspan=0)
          text = "#{label_with_style(style, label)} #{cell(value, colspan)}"
        end

        def labeled_cell(label, value, colspan=0)
          labeled_cell_with_style('label', label, value, colspan)
        end

        def labeled_cell_medium(label, value, colspan=0)
          labeled_cell_with_style('label-medium', label, value, colspan)
        end

        def labeled_cell_narrow(label, value, colspan=0)
          labeled_cell_with_style('label-narrow', label, value, colspan)
        end

        # Return a set of rows
        def list(the_hash)
          return if the_hash.nil? || the_hash.empty?
          text = ""
          the_hash.each do |k, v|
            text += "<tr>#{labeled_cell(k, v)}</tr>\n"
          end
          text
        end

        # Helper method to make it easy to display only those delays that are present
        def list_of_delays
          list = {}
          delays = [
              ["Dispatch", @parser.E02_06],
              ["Response", @parser.E02_07],
              ["Scene", @parser.E02_08],
              ["Transport", @parser.E02_09],
              ["Turn-Around", @parser.E02_10]
          ]
          delays.each { |pair| list.merge!(get_delay(*pair)) }
          list.clear if list.values.all? { |v| v =~ /None/i }
          list
        end

        def get_delay(type, value)
          return {} if value.empty?
          delay = {type => value}
          delay
        end

        # Return a list of ;-separated items
        def concat_list(items)
          items.select { |v| !v.strip!.nil? }.join('; ')
        end

        protected
        ###
        # This method will render the runsheet as an HTML file based on a template and spec YAML file
        # Set fancy_html to true to get a more colorful set of HTML results
        # Pass in a created_at date to help identify proper version (in case there are some issues with message send failures)
        def render_template(fancy_html=false, created_at=nil)
          @fancy_html          = fancy_html
          @runsheet_created_at = created_at || Time.now
          erb_file             = File.expand_path('../templates/runsheet.html.erb', __FILE__)
          template             = File.read(erb_file)
          renderer             = ERB.new(template)
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
