require 'rubygems'
require 'bundler/setup'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nemsis'

def write_html_file(name, type, html)
  file_name = "#{File.dirname(__FILE__)}/results/#{name.gsub('.xml', '')}-#{Time.now.strftime("%d%b")}_#{type}.html"
  file      = File.open(file_name, 'w+')
  file.puts html
  file.close
  #puts "Open this in your browser to admire your handiwork: file://localhost#{file_name}"
end


RSpec.configure do |config|
end
