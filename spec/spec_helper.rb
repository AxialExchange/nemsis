require 'rubygems'
require 'bundler/setup'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nemsis'
include AgeInWords

# Set this global flag to true in your spec to enable actually writing the file out.
# Otherwise it defaults to false to keep from cluttering up the hard drive
# and it makes the specs run _slightly_ faster (37 sec vs 40 sec)
WRITE_HTML_FILE = true

# You are probably here wondering why your file didn't print out, eh?'
def write_html_file(name, type, html)
  write_flag ||= WRITE_HTML_FILE
  if write_flag
    file_name = "#{File.dirname(__FILE__)}/results/#{name.gsub('.xml', '')}-#{Time.now.strftime("%d%b")}_#{type}.html"
    file      = File.open(file_name, 'w+')
    file.puts html
    file.close
    #puts "Open this in your browser to admire your handiwork: file://localhost#{file_name}"
  end
end


RSpec.configure do |config|
end
