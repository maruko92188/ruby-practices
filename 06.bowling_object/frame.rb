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

  def score()
    # フレームごとのスコアを計算する
    # ボーナスの計算のために、2つ先までのフレームの情報が必要
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
end
