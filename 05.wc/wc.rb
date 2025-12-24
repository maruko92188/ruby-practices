#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8

def main
  options = parse_options
  command_arguments = ARGV

  command_arguments.empty? ? display_input_from_pipe(options) : display_input_from_command_line(command_arguments, options)
end

def parse_options
  options = { lines: false, words: false, byte: false }
  opt = OptionParser.new
  opt.on('-l') { options[:lines] = true }
  opt.on('-w') { options[:words] = true }
  opt.on('-c') { options[:byte] = true }
  opt.parse!(ARGV)

  if options.values.none?
    options.transform_values! { |value| true}
  end
  options
end

def display_input_from_pipe(options)
  contents = $stdin.read
  lines = contents.count("\n").to_s.rjust(WIDTH)
  words =  contents.split(' ').size.to_s.rjust(WIDTH)
  byte = contents.size.to_s.rjust(WIDTH)
  row = []
  row << lines if options[:lines]
  row << words if options[:words]
  row << byte if options[:byte]
  puts row.join
end

def display_input_from_command_line(command_arguments, options)
  row_table = format_row_table(command_arguments)
  row_table.each do |rows|
    row = []
    row << rows[:lines] if options[:lines]
    row << rows[:words] if options[:words]
    row << rows[:byte] if options[:byte]
    row << rows[:file_name]
    puts row.join
  end
  display_total(row_table, options) if command_arguments.size >= 2
end

def format_row_table(command_arguments)
  file_names = command_arguments
  file_names.map do |file_name|
    contents = File.read(file_name)
    {
      lines: contents.count("\n").to_s.rjust(WIDTH),
      words: contents.split(' ').size.to_s.rjust(WIDTH),
      byte: contents.size.to_s.rjust(WIDTH),
      file_name: " #{file_name}"
    }
  end
end

ef display_total(row_table, options)
  total_table = %i[lines words byte].to_h do |key|
    total_count = row_table.sum { |rows| rows[key].to_i}
    [key, total_count.to_s.rjust(WIDTH)]
  end
  total_row = []
  total_row << total_table[:lines] if options[:lines]
  total_row << total_table[:words] if options[:words]
  total_row << total_table[:byte] if options[:byte]
  total_row << ' total'
  puts total_row.join
end

main
