# frozen_string_literal: true

class Shot
  STRIKE_SHOT = 'X'
  FULL_SCORE = 10

  def initialize(roll)
    @roll = roll
  end

  def pins
    strike? ? FULL_SCORE : @roll.to_i
  end

  def strike?
    @roll == STRIKE_SHOT
  end
end
