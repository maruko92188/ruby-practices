# frozen_string_literal: true

class Frame

  FULL_SCORE = 10

  def initialize(shots)
    @shots = shots
  end

  def self.build(pins)
    pins.each_slice(2).map { |shots| Frame.new(shots)}
  end

  def score(next_frame, after_next_frame)
    return sum if open_frame?

    sum + bonus(next_frame, after_next_frame)
  end

  def open_frame?
    sum < FULL_SCORE
  end

  def double?(next_frame)
    strike? && next_frame.strike?
  end

  def strike?
    first_shot == FULL_SCORE
  end

  def spare?
    !strike? && sum == FULL_SCORE
  end

  def first_shot
    @shots.first
  end

  def sum
    @shots.sum
  end

  private

  def bonus(next_frame, after_next_frame)
    if double?(next_frame)
      FULL_SCORE + after_next_frame.first_shot
    elsif strike?
      next_frame.sum
    elsif spare?
      next_frame.first_shot
    end
  end
end
