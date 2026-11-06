# frozen_string_literal: true

class Frame
  FULL_ROLLS = 2

  def initialize(shots)
    @shots = shots
  end

  def score(next_frame = nil, after_next_frame = nil)
    return sum if next_frame.nil? || open?

    sum + bonus(next_frame, after_next_frame)
  end

  def open?
    sum < Shot::FULL_SCORE
  end

  def strike?
    first_shot.strike?
  end

  def spare?
    !strike? && sum == Shot::FULL_SCORE
  end

  def first_shot
    @shots.first
  end

  def second_shot
    @shots[1]
  end

  def sum
    @shots.sum(&:pins)
  end

  def shot_count
    @shots.size
  end

  private

  def bonus(next_frame, after_next_frame)
    next_pins = next_frame.first_shot.pins
    return next_pins if spare?

    next_pins +
      if after_next_frame.nil? || full_rolls?(next_frame)
        next_frame.second_shot.pins
      else
        after_next_frame.first_shot.pins
      end
  end

  def full_rolls?(next_frame)
    next_frame.shot_count == FULL_ROLLS
  end
end
