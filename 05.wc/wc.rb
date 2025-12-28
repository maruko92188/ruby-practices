#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8

def main
  options = parse_options
  targets = build_target_table
  targets.each do |target|
    content_table = build_content_table(target)
    row_table = format_row_table(content_table)
    display_row(row_table, options)
  end
end

def parse_options
  options = { lines: false, words: false, byte: false }
  opt = OptionParser.new
  opt.on('-l') { options[:lines] = true }
  opt.on('-w') { options[:words] = true }
  opt.on('-c') { options[:byte] = true }
  opt.parse!(ARGV)

  options.each_key { |key| options[key] = true } if options.values.none?
  options
end

def build_target_table
  if ARGV.empty?
    [{ input: $stdin, name: nil }]
  else
    ARGV.map { |file_name| { input: file_name, name: file_name } }
  end
end

def build_content_table(target)
  content =
    if target[:input] == $stdin
      target[:input].read
    else
      File.read(target[:input])
    end
  { content:, name: target[:name] }
end

def format_row_table(content_table)
  {
    lines: content_table[:content].count("\n"),
    words: content_table[:content].split(' ').size,
    byte: content_table[:content].size,
    name: " #{content_table[:name]}"
  }
end

def display_row(row_table, options)
  row = %i[lines words byte].map do |key|
    row_table[key].to_s.rjust(WIDTH) if options[key]
  end
  row << row_table[:name]
  puts row.join
end

main
