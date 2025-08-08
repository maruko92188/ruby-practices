#! /usr/bin/env ruby
# frozen_string_literal: true

scores = ARGV[0].split(',')
shots = []
scores.each { |score| score == 'X' ? shots << 10 << 0 : shots << score.to_i }

calculation_frames = shots.each_slice(2).to_a

ordinary_point = calculation_frames.sum(&:sum)

additonal_point = calculation_frames[0..8].each_with_index.sum do |bonus_frame, index|
  one_frame_ahead = index + 1
  two_frames_ahead = index + 2
  if (bonus_frame[0] == 10) && (calculation_frames[one_frame_ahead][0] == 10)
    10 + calculation_frames[two_frames_ahead][0]
  elsif bonus_frame[0] == 10
    calculation_frames[one_frame_ahead].sum
  elsif bonus_frame.sum == 10
    calculation_frames[one_frame_ahead][0]
  else
    0
  end
end

puts "スコアは#{ordinary_point + additonal_point}です。"
