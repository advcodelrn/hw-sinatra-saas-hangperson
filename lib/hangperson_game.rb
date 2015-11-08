class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess(letter)
    raise ArgumentError if (letter.nil? || 
                            letter.empty? || 
                            !letter.match(/^[[:alpha:]]+$/))
    # return false if the letter is already has been guessed
    letter = letter.downcase
    return false if (@guesses + @wrong_guesses).include? letter
    if @word.include? letter
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    true
  end
  
  def word_with_guesses
    @word.each_char.map do |letter|
      if @guesses.include? letter
        letter
      else
        '-'
      end
    end.join
  end
  
  def check_win_or_lose
    if @wrong_guesses.length > 6
      return :lose
    elsif @word.each_char.all? { |letter| @guesses.include? letter }
      return :win
    else
      return :play
    end
  end
end
