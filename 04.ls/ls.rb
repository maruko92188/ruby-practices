#! /usr/bin/env ruby
# frozen_string_literal: true

COLUMNS = 3
TAB_WIDTH = 8

require 'optparse'

def main
  file_names = search_file_names
  return if file_names.empty?

  build_file_names_table(file_names).each do |row|
    puts row.join.rstrip
  end
end

def search_file_names
  options = ARGV.getopts('a')
  raw_file_names = options['a'] ? Dir.entries('.') : Dir['*']
  raw_file_names.sort_by(&:downcase)
end

def build_file_names_table(file_names)
  rows = file_names.size.ceildiv(COLUMNS)
  additional_blanks = COLUMNS * rows - file_names.size
  full_file_names = add_tab_characters(file_names) + Array.new(additional_blanks)
  sliced_file_names = full_file_names.each_slice(rows).to_a
  sliced_file_names.transpose
end

def add_tab_characters(file_names)
  column_width = calculate_column_width(file_names)
  file_names.map do |file_name|
    tab_count = column_width - file_name.size.div(TAB_WIDTH)
    "#{file_name}#{"\t" * tab_count}"
  end
end

def calculate_column_width(file_names)
  longest_file_name = file_names.max_by(&:size).size
  longest_file_name.div(TAB_WIDTH) + 1
end

main
