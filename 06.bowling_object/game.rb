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
      next_frame = @frames[index + 1]
      after_next_frame = @frames[index + 2]
      current_frame.score(next_frame, after_next_frame)
    end
  end

  private

  def build_frame(rolls)
    shots = rolls.map { |roll| Shot.new(roll) }
    frames = 9.times.map do
      first_shot = shots.shift
      if first_shot.strike?
        Frame.new([first_shot])
      else
        second_shot = shots.shift
        Frame.new([first_shot, second_shot])
      end
    end
    frames << Frame.new(shots)
  end
end
