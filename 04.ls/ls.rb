#! /usr/bin/env ruby
# frozen_string_literal: true

COLUMNS = 3
COLUMNS_DISTANCE = 5

def main(file_names)
  return exit if file_names.empty?
  longest_file_name = file_names.max_by(&:size)
  width = longest_file_name.size + COLUMNS_DISTANCE
  build_output_file_names(file_names).each do |row|
    row.each do |file_name|
      print file_name.to_s.ljust(width)
    end
    puts
  end
end

def build_output_file_names(file_names)
  rows = file_names.size.ceildiv(COLUMNS)
  additional_blanks = COLUMNS * rows - file_names.size
  full_file_names = file_names + Array.new(additional_blanks)
  sliced_file_names = full_file_names.each_slice(rows).to_a
  sliced_file_names.transpose
end

def file_names
  Dir['*'].sort_by(&:downcase)
end

main(file_names)
