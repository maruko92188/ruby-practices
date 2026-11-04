# frozen_string_literal: true

class Frame
  FULL_ROLLS = 2

  def initialize(shots)
    @shots = shots
  end

  def score(next_frame, after_next_frame)
    return sum if last?(next_frame) || open?

    sum + bonus(next_frame, after_next_frame)
  end

  def last?(next_frame)
    next_frame.nil?
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
    return next_frame.first_shot.pins if spare?

    if after_next_frame.nil?
      next_frame.first_shot.pins + next_frame.second_shot.pins
    else
      next_frame.sum + (full_rolls?(next_frame) ? 0 : after_next_frame.first_shot.pins)
    end
  end

  def full_rolls?(next_frame)
    next_frame.shot_count == FULL_ROLLS
  end
end
