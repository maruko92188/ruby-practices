# frozen_string_literal: true

require_relative './game.rb'

game = Game.new(ARGV[0])
puts game.score
