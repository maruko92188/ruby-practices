# frozen_string_literal: true

class Game
  # 入力値から倒したピンの本数を保持した配列を作る
  # 倒したピンの本数をFramに渡して計算用のデータを作ってもらう
  # 計算用のデータをFrameに渡してスコアを計算してもらう

  STRIKE = 'X'
  STRIKE_SHOTS = [10, 0]

  def initialize(result)
    pins = parse_result(result)
    @frames = Frame.build(pins)
  end

  def score
    # Frameに計算用のデータを渡してスコア計算をさせる
  end

  def parse_result(result)
    result.split(',').flat_map { |shot| shot == STRIKE ? STRIKE_SHOTS : shot.to_i}
  end
end
