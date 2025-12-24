#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8

def main
  options = parse_options
  tergets = ARGV.empty? ? [$stdin] : ARGV
  tergets.each do |terget|
    content_table = collect_content(terget)
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

  if options.values.none?
    options.transform_values! { |value| true}
  end
  options
end

def collect_content(terget)
  content = ARGV.empty? ? terget.read : File.read(terget)
  name = ARGV.empty? ? nil : "#{terget}"
  { content:, name: }
end

def format_row_table(content_table)
  {
    lines: content_table[:content].count("\n").to_s.rjust(WIDTH),
    words: content_table[:content].split(' ').size.to_s.rjust(WIDTH),
    byte: content_table[:content].size.to_s.rjust(WIDTH),
    name: " #{content_table[:name]}"
  }
end

def display_row(row_table, options)
  row = %i[lines words byte].map do |key|
    row_table[key] if options[key]
  end
  row << row_table[:name]
  puts row.join
end

main
