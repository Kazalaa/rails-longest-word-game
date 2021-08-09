# require "pry-byebug"
require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @input_user = params[:word]
    @include_letter = includeLetters(@input_user, @letters)
    @valid_english = validEnglishWord()
    @is_valid = isValid?()
  end

  def isValid?
    if @include_letter && @valid_english
      "Congratulations! #{@input_user} is a valid English word!"
    elsif @include_letter && @valid_english != true
      "Sorry but #{@input_user} does not seem to be a valid English word..."
    else
      "Sorry but #{@input_user} can't be built out of #{@letters} "
    end
  end

  def includeLetters(grid_user, grid_letters)
    grid_user.chars.all? do |letter|
      grid_user.count(letter) <= grid_letters.count(letter)
    end
  end

  def validEnglishWord
    url = "https://wagon-dictionary.herokuapp.com/#{@input_user}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    word["found"]
  end
end
