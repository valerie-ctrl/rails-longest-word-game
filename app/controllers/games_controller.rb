require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @random_letters = []
    10.times { @random_letters << ('A'..'Z').to_a.sample }
  end

  def score
    random_letters = params[:random_letters].gsub(" ", "").upcase.chars
    letters = params[:random_letters].gsub(" ", "").upcase.chars
    user_input = params[:word].upcase
    if json_parse(user_input)["found"] == false && in_grid?(user_input, random_letters) == true
      @message = "Sorry, but #{user_input.upcase} does not seem to be an English word..."
    elsif in_grid?(user_input, random_letters) == true && json_parse(user_input)["found"] == true
      @message = "Congradulations! #{user_input.upcase} is a valid English word!"
    else
      @message = "Sorry, but #{user_input.upcase} can't be built out of #{letters.join(",")}"
    end
  end

  def in_grid?(attempt, grid)
    attempt.upcase.chars.each do |char|
      if grid.include?(char)
        grid.delete_at(grid.find_index(char))
      else
        return false
      end
    end
    return true
  end

  def json_parse(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    response_serialized = URI.open(url).read
    JSON.parse(response_serialized)
  end
end
