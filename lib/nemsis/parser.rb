require 'nokogiri'
require 'yaml'

module Nemsis
  class Parser
    attr_accessor :xml_str, :xml_doc

    class << self
      attr_accessor :spec
    end

    spec_yaml = File.expand_path('../../../conf/nemsis_spec.yml', __FILE__)
    @@spec    = YAML::load(File.read(spec_yaml))

    def initialize(xml_str)
      raise ArgumentError.new('Parser initiation requires XML String argument') if xml_str.nil? or xml_str.size == 0
      self.xml_str = xml_str
      self.xml_doc = Nokogiri::XML(xml_str)
      xml_doc.remove_namespaces!
    end

    def parse(element_spec)
      xpath = "//#{element_spec['node']}"

      begin
        nodes = xml_doc.xpath(xpath) or return

        #puts element_spec.inspect if ["E23_08", "E29_03", "E24_01"].include?(element_spec["node"])

        case element_spec['is_multi_entry']
          when 1
            values = []
            nodes.each do |node|
              values << get_value(element_spec, node)
            end
            return values
          else
            node = nodes.first or return
            value = get_value(element_spec, node)
            return value
        end

      rescue => err
        puts "Error: parsing xpath [#{xpath}] #{err}"
      end
    end

    # niche method, only returns a single value
    def index(element)
      text = ''

      begin
        nodes = xml_doc.xpath("//#{@@spec[element]['node']}") or return -99
        text = nodes.first.text if nodes.size > 0
      rescue => err
        puts "Error: parsing xpath [#{xpath}] #{err}"
      end

      text
    end

    def name(element)
      get(element)[:name]
    end

    def get(element)
      element_spec = @@spec[element]
      name = element_spec["name"]
      value = parse_element(element)
      {:name => name, :value => value}
    end

    def parse_element(element)
      element_spec = @@spec[element]

      puts "NOTICE: '#{element}' is null!!" if element_spec.nil?
      results = parse(element_spec)

      results.is_a?(Array) ? results.first : results
    end

    def parse_time(element, full=false)
      time_str = parse_element(element)

      if full
        Time.parse(time_str).strftime("%Y-%m-%d %H:%M") rescue nil
      else
        Time.parse(time_str).strftime("%H:%M") rescue nil
      end
    end

    def parse_date(element, full=true)
      date_str = parse_element(element)

      if full
        Time.parse(date_str).strftime("%Y-%m-%d") rescue nil
      else
        Time.parse(date_str).strftime("%m-%d") rescue nil
      end
    end

    def parse_state(element)
      state_code = parse_element(element)

      state_codes = {"42" => "PA", "01" => "AL", "02" => "AK", "04" => "AZ", "05" => "AR", "06" => "CA", "08" => "CO", "09" => "CT", "10" => "DE", "11" => "DC", "12" => "FL", "13" => "GA", "15" => "HI", "16" => "ID", "17" => "IL", "18" => "IN", "19" => "IA", "20" => "KS", "21" => "KY", "22" => "LA", "23" => "ME", "24" => "MD", "25" => "MA", "26" => "MI", "27" => "MN", "28" => "MS", "29" => "MO", "30" => "MT", "31" => "NE", "32" => "NV", "33" => "NH", "34" => "NJ", "35" => "NM", "36" => "NY", "37" => "NC", "38" => "ND", "39" => "OH", "40" => "OK", "41" => "OR", "44" => "RI", "45" => "SC", "46" => "SD", "47" => "TN", "48" => "TX", "49" => "UT", "50" => "VT", "51" => "VA", "53" => "WA", "54" => "WV", "55" => "WI", "56" => "WY", "60" => "AS", "66" => "GU", "69" => "MP", "72" => "PR", "74" => "UM", "78" => "VI"}

      state_codes[state_code] || state_code
    end

    def parse_field(field_name)
      element_spec = @@spec.values.
          select { |v| v['name'] == field_name }.
          first

      parse(element_spec)
    end

    def parse_pair(name_element, value_element)
      name_element_spec = @@spec[name_element]
      names             = parse(name_element_spec)

      value_element_spec = @@spec[value_element]
      values             = parse(value_element_spec)

      result = {}
      begin
        names.size.times { |i| result[names[i]] = values[i] }
      rescue
      end

      result
    end

    def parse_value_of(key)
      parse_pair('E23_11', 'E23_09')[key] rescue nil
    end

    def parse_cluster(element)
      xpath    = "//#{element}"
      nodes    = xml_doc.xpath(xpath)
      # puts nodes.count

      clusters = []
      begin
        nodes.each do |node|
          cluster = Nemsis::Parser.new(node.to_s)
          clusters << cluster
        end
      rescue => err
        puts "Error: parsing xpath [#{xpath}]: #{err}"
      end

      clusters
    end

    def parse_clusters(*cluster_elements)
      results = []
      cluster_elements.each do |element|
        results = results + parse_cluster(element)
      end

      results
    end

    def parse_assessments
      # Assessments elements are E15 and E16.  There would be just one E15 and
      # many E16 elements.  Sort E16 element clusters by time E16_03, and the
      # first one would be Initial Assessment.  The single E15 element is always
      # part of the initial assessment, so it will need to be combined with the
      # earliest E16.
      e15_clusters           = parse_cluster('E15')
      e15_initial_assessment = e15_clusters.shift

      e16_clusters           = parse_clusters('E16')
      e16_clusters           = e16_clusters.sort_by { |c| Time.parse(c.sub_element('03')) rescue Time.now }
      e16_initial_assessment = e16_clusters.shift

      initial_assessment_node = Nokogiri::XML::Node.new("E15_E16", xml_doc)
      initial_assessment_node.add_child e15_initial_assessment.xml_doc.root
      initial_assessment_node.add_child e16_initial_assessment.xml_doc.root

      initial_assessment = Nemsis::Parser.new(initial_assessment_node.to_s)

      assessments = [initial_assessment, e16_clusters].flatten

      assessments
    end

    def root_element_name
      xml_doc.root.name
    end

    def sub_element(element_suffix)
      parse_element("#{root_element_name}_#{element_suffix}")
    end

    def concat(*elements)
      elements.map do |elem|
        parse_element(elem)
      end.compact.join(' ')
    end

    # Return a string
    def method_missing(method_sym, *arguments, &block)
      if method_sym.to_s =~ /^[A-Z]\d{2}(_\d{2})?/
        Array(parse(@@spec[method_sym.to_s])).join(', ') rescue ''
      else
        super
      end
    end

    def respond_to?(method_sym, include_private = false)
      if method_sym.to_s =~ /^[A-Z]\d{2}(_\d{2})?/
        true
      else
        super
      end
    end

    def get_value(element_spec, node)
      value = node.text

      # Note: data_type possible values are
      # ["text", "combo", "date/time", "number", "date", "time", "combo or text", "binary"]
      if element_spec['data_type'] =~ /(text|combo|combo or text)/i &&
          value =~ /^-?\d+$/ &&
          !element_spec['field_values'].nil?

        # Blank out "Not Recorded" values
        element_spec['field_values'].merge!(
            -10 => '', # Not Known
            -15 => '', # Not Reporting
            -20 => '', # Not Recorded
            -25 => '', # Not Applicable
            -5  => '' # Not Available
        )
        #if ["E23_08", "E29_03", "E24_01"].include?(element_spec["node"])
        #  puts " [S] Lookup #{value.to_i} in #{element_spec["node"]} values: #{element_spec['field_values'].inspect}"
        #end
        mapped_value = element_spec['field_values'][value.to_i]
        case mapped_value
          when false
            mapped_value = 'No'
          when true
            mapped_value = 'Yes'
        end

        value = mapped_value unless mapped_value.nil?
      elsif element_spec['data_type'] =~ /date\/time/i
        value = Time.parse(value).strftime("%Y-%m-%d %H:%M") rescue nil
      elsif element_spec['data_type'] =~ /date/i
        value = Time.parse(value).strftime("%Y-%m-%d") rescue nil
      elsif element_spec['data_type'] =~ /time/i
        value = Time.parse(value).strftime("%H:%M") rescue nil
      elsif element_spec['data_type'] =~ /number/i
        f      = sprintf("%.1e", value).to_f
        i      = f.to_i
        value  = (i == f ? i : f)
      end

      value
    end

  end
end
