#! /usr/bin/env ruby
# frozen_string_literal: true

COLUMNS = 3
TAB_WIDTH = 8

def main
  file_names = create_file_names
  return if file_names.empty?

  longest_file_name = file_names.max_by(&:size).size
  build_file_names_table(file_names).each do |row|
    last_columns_number = row.size
    row.each.with_index(1) do |file_name, index|
      tab_count = longest_file_name.div(TAB_WIDTH) + 1 - file_name.to_s.size.div(TAB_WIDTH)
      print index == last_columns_number ? file_name : "#{file_name}#{"\t" * tab_count}"
    end
    puts
  end
end

def build_file_names_table(file_names)
  rows = file_names.size.ceildiv(COLUMNS)
  additional_blanks = COLUMNS * rows - file_names.size
  full_file_names = file_names + Array.new(additional_blanks)
  sliced_file_names = full_file_names.each_slice(rows).to_a
  sliced_file_names.transpose
end

def create_file_names
  Dir['*'].sort_by(&:downcase)
end

main
