require 'rubygems'
require 'bundler/setup'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nemsis'
include AgeInWords

# By default, generated .html files will be written to spec/results directory.
# To supress writing files, set environment variable WRITE_HTML_FILE=false
def write_html_file(name, type, html)
  if ENV['WRITE_HTML_FILE'] != 'false'
    file_name = "#{File.dirname(__FILE__)}/results/#{name.gsub('.xml', '')}-#{Time.now.strftime("%d%b")}_#{type}.html"
    file      = File.open(file_name, 'w+')
    file.puts html
    file.close
  end
end

RSpec.configure do |config|
end
