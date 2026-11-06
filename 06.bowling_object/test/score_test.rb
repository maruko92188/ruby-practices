# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../game'

class Scoretest < Minitest::Test
  def test_score
    test_cases = [
      { name: 'パーフェクトゲーム', result: 'X,X,X,X,X,X,X,X,X,X,X,X', expected: 300 },
      { name: '通常ゲーム', result: '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4', expected: 107 },
      { name: 'オールガター', result: '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', expected: 0 },
      { name: 'オールスペア', result: '5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5', expected: 150 },
      { name: '最終フレームでストライク', result: '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,X,X,X', expected: 30 }
    ]
    test_cases.each do |test_case|
      frames = Game.new(test_case[:result])
      actual = frames.score
      assert_equal test_case[:expected], actual, "「#{test_case[:name]}」で失敗"
    end
  end
end
