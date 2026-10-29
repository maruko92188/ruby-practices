# frozen_string_literal: true

require_relative './frame'

class Game
  STRIKE = 'X'
  STRIKE_SHOTS = [10, 0].freeze

  def initialize(result)
    pins = parse_result(result)
    @frames = Frame.build(pins)
  end

  def score
    score = @frames[0..8].each_with_index.sum do |current_frame, index|
      next_frame = @frames[index.next]
      after_next_frame = @frames[index.next.next]
      current_frame.score(next_frame, after_next_frame)
    end
    score + @frames.drop(9).sum(&:sum)
  end

  private

  def parse_result(result)
    result.split(',').flat_map { |shot| shot == STRIKE ? STRIKE_SHOTS : shot.to_i }
  end
end
