require 'open-uri'

class GamesController < ApplicationController

  def new
    chars = ("A".."Z").to_a
    @letters = 10.times.map { chars.sample }
  end
  
  def score
    word_json = URI.open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read
    json_list = JSON.parse(word_json)

    com_attempt = ""
    attempt = params[:word]
    @letters = params[:letters].chars

    attempt.upcase.chars.each do |char|
      if @letters.include?(char)
        com_attempt << char
        @letters.delete_at(@letters.index(char))
      end
    end

    if (com_attempt.downcase == attempt) && (json_list["found"] == true)
      @message = "The word is valid according to the grid and is an English word ✅"
    elsif (com_attempt.downcase != attempt)
      @message = "The word can’t be built out of the original grid ❌"
    elsif (com_attempt.downcase == attempt) && (json_list["found"] != true)
      @message = "The word is valid according to the grid, but is not a valid English word ❌"
    end
  end
end
