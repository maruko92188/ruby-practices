# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def initialize(result)
    rolls = result.split(',')
    @frames = build_frame(rolls)
  end

  def score
    @frames.each_with_index.sum do |current_frame, index|
      current_frame.score(*@frames[index + 1, 2])
    end
  end

  private

  def build_frame(rolls)
    shots = rolls.map { |roll| Shot.new(roll) }
    frames = 9.times.map do
      frame_shots = shots.first.strike? ? shots.shift : shots.shift(Frame::FULL_ROLLS)
      Frame.new([*frame_shots])
    end
    frames << Frame.new(shots)
  end
end
