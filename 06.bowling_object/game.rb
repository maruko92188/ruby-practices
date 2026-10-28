# frozen_string_literal: true

require_relative './frame.rb'

class Game

  STRIKE = 'X'
  STRIKE_SHOTS = [10, 0]

  def initialize(result)
    pins = parse_result(result)
    @frames = Frame.build(pins)
  end

  def score
    socre = @frames.each_cons(3).take(9).sum do |current_frame, next_frame, after_next_frame|
      current_frame.score(current_frame, next_frame, after_next_frame)
    end
    score + @frames.drop(9).sum(&:sum)
  end

  private

  def parse_result(result)
    result.split(',').flat_map { |shot| shot == STRIKE ? STRIKE_SHOTS : shot.to_i}
  end
end
