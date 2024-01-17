require 'uri'
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(7)
    @letters += %w[A E I U O].sample(3)
  end

  def score
    @message = word_check
    @result = result(@word)
    redirect_to new_path if @word.nil?
  end

  def result(word)
    return 0 unless valid?(word) && can_be_built?

    score = 2**word.length
    "Your score is #{score}"
  end

  def word_check
    @word = params[:word]
    if !can_be_built?
      "Sorry, your word cannot be built out of #{params[:letters]}"
    elsif !valid?(@word)
      "Sorry, our dictionary doesn't have the word #{@word}!"
    else
      "Congratulations! #{@word.upcase} is a valid word!"
    end
  end

  def can_be_built?
    letters = params[:letters].split
    @word.upcase.chars.all? do |letter|
      letters.include?(letter)
      letters.delete(letter)
    end
  end

  def valid?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url)
    json = JSON.parse(response.read)
    json['found']
  end

  def show_score
    @word = params[:word]
  end
end
