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
  '0': '---',
  '1': '--x',
  '2': '-w-',
  '3': '-wx',
  '4': 'r--',
  '5': 'r-x',
  '6': 'rw-',
  '7': 'rwx'
}.freeze

def main
  options = ARGV.getopts('alr')
  searched_file_names = options['a'] ? Dir['..', '.*', '*'] : Dir['*']
  sorted_file_names = searched_file_names.sort_by(&:downcase)
  file_names = options['r'] ? sorted_file_names.reverse : sorted_file_names
  options['l'] ? display_long_format(file_names) : display_column_format(file_names)
end

def display_long_format(file_names)
  long_formats = build_long_format_table(file_names)
  total_blocks = long_formats.sum { |format| format[:blocks] }
  puts "total #{total_blocks}"

  widths = caluculate_max_length(long_formats)
  long_formats.each do |format|
    rows = [
      "#{format[:file_mode]} ",
      format[:hard_links].rjust(widths[:link_width]),
      "#{format[:owner_name].ljust(widths[:owner_width])} ",
      "#{format[:group_name].ljust(widths[:group_width])} ",
      format[:byte_size].rjust(widths[:byte_width]),
      format[:last_modified_time],
      format[:path_name]
    ]
    puts rows.join(' ')
  end
end

def build_long_format_table(file_names)
  file_names.map do |file_name|
    status = File.lstat(file_name)
    {
      file_mode: "#{ENTRY_TYPES[status.ftype.to_sym]}#{create_permissions(status)}",
      hard_links: status.nlink.to_s,
      owner_name: Etc.getpwuid(status.uid).name,
      group_name: Etc.getgrgid(status.gid).name,
      byte_size: status.blockdev? || status.chardev? ? format('%#x', status.rdev) : status.size.to_s,
      last_modified_time: create_last_modified_time(status),
      path_name: status.symlink? ? "#{file_name} -> #{File.readlink(file_name)}" : file_name,
      blocks: status.blocks
    }
  end
end

def create_permissions(status)
  permissions = status.mode.to_s(8)[-3..].chars.map do |octal|
    FILE_PERMISSIONS[octal.to_sym]
  end.join
  apply_setuid(permissions) if status.setuid?
  apply_setgid(permissions) if status.setgid?
  apply_sticky(permissions) if status.sticky?
  permissions
end

def apply_setuid(permissions)
  permissions[2] = permissions[2].eql?('x') ? 's' : 'S'
end

def apply_setgid(permissions)
  permissions[5] = permissions[5].eql?('x') ? 's' : 'S'
end

def apply_sticky(permissions)
  permissions[8] = permissions[8].eql?('x') ? 't' : 'T'
end

def create_last_modified_time(status)
  half_a_year_seconds = (60 * 60 * 24) * (365.2425 / 2)
  differnce = Time.now - status.mtime
  if differnce > half_a_year_seconds
    status.mtime.strftime('%_m %e  %Y')
  else
    status.mtime.strftime('%_m %e %R')
  end
end

def caluculate_max_length(long_formats)
  {
    link_width: long_formats.map { |format| format[:hard_links].size }.max,
    owner_width: long_formats.map { |format| format[:owner_name].size }.max,
    group_width: long_formats.map { |format| format[:group_name].size }.max,
    byte_width: long_formats.map { |format| format[:byte_size].size }.max
  }
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
