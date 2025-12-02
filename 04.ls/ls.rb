#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMNS = 3
TAB_WIDTH = 8

ENTRY_TYPES = {
  file: '-',
  blockSpecial: 'b',
  characterSpecial: 'c',
  directory: 'd',
  link: 'l',
  fifo: 'p',
  socket: 's',
  unknown: 'w'
}.freeze

FILE_PERMISSIONS = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

HALF_A_YEAR_SECONDS = (60 * 60 * 24) * (365.2425 / 2)

def main
  options = ARGV.getopts('alr')
  searched_file_names = options['a'] ? Dir['..', '.*', '*'] : Dir['*']
  sorted_file_names = searched_file_names.sort_by(&:downcase)
  file_names = options['r'] ? sorted_file_names.reverse : sorted_file_names
  options['l'] ? display_long_format(file_names) : display_column_format(file_names)
end

def display_long_format(file_names)
  file_status_table = build_file_status_table(file_names)
  total_blocks = file_status_table.sum { |file_status| file_status[:blocks] }
  puts "total #{total_blocks}"

  widths = create_long_format_widths(file_status_table)
  file_status_table.each do |file_status|
    rows = [
      "#{file_status[:file_mode]} ",
      file_status[:hard_links].rjust(widths[:hard_links]),
      "#{file_status[:owner_name].ljust(widths[:owner_name])} ",
      "#{file_status[:group_name].ljust(widths[:group_name])} ",
      file_status[:byte_size].rjust(widths[:byte_size]),
      file_status[:last_modified_time],
      file_status[:path_name]
    ]
    puts rows.join(' ')
  end
end

def build_file_status_table(file_names)
  file_names.map do |file_name|
    status = File.lstat(file_name)
    byte_size = status.blockdev? || status.chardev? ? format('%#x', status.rdev) : status.size.to_s
    path_name = status.symlink? ? "#{file_name} -> #{File.readlink(file_name)}" : file_name
    {
      file_mode: "#{ENTRY_TYPES[status.ftype.to_sym]}#{create_permissions(status)}",
      hard_links: status.nlink.to_s,
      owner_name: Etc.getpwuid(status.uid).name,
      group_name: Etc.getgrgid(status.gid).name,
      byte_size:,
      last_modified_time: create_last_modified_time(status),
      path_name:,
      blocks: status.blocks
    }
  end
end

def create_permissions(status)
  octals = status.mode.to_s(8)[-3..].chars
  special_bits_table = [
    [status.setuid?, 's'],
    [status.setgid?, 's'],
    [status.sticky?, 't']
  ]
  octals.zip(special_bits_table).map do |octal, (is_special, special_symbol)|
    standard_permissions = FILE_PERMISSIONS[octal]
    if is_special
      apply_special_permission(standard_permissions, special_symbol)
    else
      standard_permissions
    end
  end.join
end

def apply_special_permission(standard_permissions, special_symbol)
  read = standard_permissions[0]
  write = standard_permissions[1]
  execute = standard_permissions.end_with?('x') ? special_symbol : special_symbol.upcase
  "#{read}#{write}#{execute}"
end

def create_last_modified_time(status)
  differnce = Time.now - status.mtime
  format = differnce > HALF_A_YEAR_SECONDS ? '%_m %e  %Y' : '%_m %e %R'
  status.mtime.strftime(format)
end

def create_long_format_widths(file_status_table)
  {
    hard_links: calculate_max_width(file_status_table, :hard_links),
    owner_name: calculate_max_width(file_status_table, :owner_name),
    group_name: calculate_max_width(file_status_table, :group_name),
    byte_size: calculate_max_width(file_status_table, :byte_size)
  }
end

def calculate_max_width(file_status_table, key)
  file_status_table.map { |file_status| file_status[key].size }.max
end

def display_column_format(file_names)
  return if file_names.empty?

  build_file_names_table(file_names).each do |row|
    puts row.join.rstrip
  end
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
