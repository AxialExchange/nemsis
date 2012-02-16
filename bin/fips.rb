#!/usr/bin/env ruby
require 'rubygems'
require 'csv'

nemsis_fips_file = File.expand_path('../../conf/nemsis_fips.csv', __FILE__)

headers = []
rows = []
CSV.foreach(nemsis_fips_file) do |row|
  if headers.size > 0
    hash = Hash[headers.zip(row)]
    rows << hash
  else
    headers = row
  end
end

state_code = {}

rows.collect {|r| [r["FIPS State Code"], r["State Alpha Code"]]}.
     uniq.each do |r|
      state_code[r[0]] = r[1]
     end

puts state_code.inspect
