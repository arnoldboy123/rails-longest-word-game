require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    valid_letters = params[:valid_letters]
    answer = params[:answer]
    # need to check whether answer only has characters from the valid_letters array
    allowed = /\A[\d#{valid_letters}]+\z/i

    if !(answer.match? allowed)
      @result = "Sorry, but #{answer} can\'t be built out of #{valid_letters}"
    else
      @result = check_word(answer)
    end
  end

  def check_word(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)

    return "Sorry, but #{answer} does not seem to be a valid English word" if word['found'] == false

    return "Congratulations, #{answer} is a valid English word, your score is #{answer.length}"
  end
end
