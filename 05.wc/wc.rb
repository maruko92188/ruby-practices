#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8

def main
  options = parse_options
  targets = build_target_table
  count_table = format_count_table(targets)
  display_rows(count_table, options)
  display_total(count_table, options) if targets.size > 1
end

def parse_options
  options = { lines: false, words: false, bytes: false }
  opt = OptionParser.new
  opt.on('-l') { options[:lines] = true }
  opt.on('-w') { options[:words] = true }
  opt.on('-c') { options[:bytes] = true }
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

def format_count_table(targets)
  targets.map do |target|
    content = fetch_content(target)
    {
      lines: content[:content].count("\n"),
      words: content[:content].split(' ').size,
      bytes: content[:content].size,
      name: " #{content[:name]}"
    }
  end
end

def fetch_content(target)
  content =
    if target[:input] == $stdin
      target[:input].read
    else
      File.read(target[:input])
    end
  { content:, name: target[:name] }
end

def display_rows(count_table, options)
  count_table.each do |count|
    row = %i[lines words bytes].map do |key|
      count[key].to_s.rjust(WIDTH) if options[key]
    end
    row << count[:name]
    puts row.join.rstrip
  end
end

def display_total(count_table, options)
  totals = calculate_totals(count_table)
  row = totals.map do |key, total|
    total.to_s.rjust(WIDTH) if options[key]
  end
  row << ' total'
  puts row.join
end

def calculate_totals(count_table)
  %i[lines words bytes].to_h do |key|
    total = count_table.sum { |count| count[key] }
    [key, total]
  end
end

main
