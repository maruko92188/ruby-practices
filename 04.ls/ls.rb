#! /usr/bin/env ruby
# frozen_string_literal: true

COLUMNS = 3

def main
  created_file_names = file_names
  return if created_file_names.empty?

  width = created_file_names.max_by(&:size).size
  build_output_file_names(created_file_names).each do |row|
    row.each do |file_name|
      print "#{file_name.to_s.ljust(width)}\t"
    end
    puts
  end
end

def build_output_file_names(created_file_names)
  rows = created_file_names.size.ceildiv(COLUMNS)
  additional_blanks = COLUMNS * rows - created_file_names.size
  full_file_names = created_file_names + Array.new(additional_blanks)
  sliced_file_names = full_file_names.each_slice(rows).to_a
  sliced_file_names.transpose
end

def file_names
  Dir['*'].sort_by(&:downcase)
end

main
