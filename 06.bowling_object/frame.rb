# frozen_string_literal: true

class Frame
  # Gameから受け取った倒したピンの本数の情報から計算用のデータをつくる
  # フレームごとのスコアを計算する
  # フレームの状態（オープン？ストライク？など）を判定する
  def initialize(shots)
    # 1フレームごとの、倒したピンの本数を保持する
  end

  def score()
    # フレームごとのスコアを計算する
    # ボーナスの計算のために、2つ先までのフレームの情報が必要
  end

  def open_frame?
  end

  def double?()
    # 1つ先のフレームの情報が必要
  end

  def strike?
  end

  def spare?
  end
end
