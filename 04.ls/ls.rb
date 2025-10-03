#! /usr/bin/env ruby
# frozen_string_literal: true

COLUMNS = 3
COLUMNS_DISTANCE = 5

def main
  longest_string = file_names.max_by(&:size)
  string_width = longest_string.size + COLUMNS_DISTANCE
  make_output_file_names.each do |row|
    row.each do |file_name|
      print file_name.to_s.ljust(string_width)
    end
    puts
  end
end

def make_output_file_names
  rows = file_names.size.ceildiv(COLUMNS)
  additional_blanks = COLUMNS * rows - file_names.size
  full_file_names = file_names + Array.new(additional_blanks)
  sliced_file_names = full_file_names.each_slice(rows).to_a
  sliced_file_names.transpose
end

def file_names
  Dir['*'].sort_by(&:downcase)
end

main
