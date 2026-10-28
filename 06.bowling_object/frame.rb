# frozen_string_literal: true

class Frame
  # Gameから受け取った倒したピンの本数の情報から計算用のデータをつくる
  # フレームごとのスコアを計算する
  # フレームの状態（オープン？ストライク？など）を判定する

  FULL_SCORE = 10

  def initialize(shots)
    @shots = shots
  end

  def self.build(pins)
    pins.each_slice(2).map { |shots| Frame.new(shots)}
  end

  def score(current_frame, next_frame, after_next_frame)
    return sum if open_frame?

    sum + bonus(next_frame, after_next_frame)
  end

  def open_frame?
    @shots < FULL_SCORE
  end

  def double?(next_frame)
    strike? && next_frame.strike?
  end

  def strike?
    first_shot == FULL_SCORE
  end

  def spare?
    !strike && sum == FULL_SCORE
  end

  def first_shot
    @shots.first
  end

  def sum
    @shots.sum
  end

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
