class Dictionary
  @@dictionary = File.readlines("5desk.txt")

  def self.pick_word(min_char_length, max_char_length)
    loop do
      word = @@dictionary[rand(@@dictionary.length)].gsub("\n", "")

      return word.downcase if word.length >= min_char_length && word.length <= max_char_length
    end
  end
end

class Hangman
  @@repeat_part = []

  def self.draw_hangman(turns_left)
    hangman_parts = Hangman.hangman_parts

    hangman_parts.length.downto(turns_left) do |part| 
      
      if part == 5 && @@repeat_part.include?(5)
        next
      elsif part == 4 && @@repeat_part.include?(4)
        next
      elsif part == 2 && @@repeat_part.include?(2)
        next
      elsif part == 5 || part == 4 || part == 2
        @@repeat_part << part
      end

      puts "#{hangman_parts[part]} ".center(20)
    end
  end

  def self.hangman_parts
    gallow = "───────────" 
    noose = " \\|      | " 
    head = "  |      O " 
    body = "  |      | " 
    left_arm = "  |     /| "
    both_arms = "  |     /|\\"
    left_leg = "  |     /  " 
    both_legs = "  |     / \\" 
    ground = "──|──────────" 

    [ground, both_legs, left_leg, both_arms, left_arm, body, head, noose, gallow]
  end
end

class Player

  def self.get_guess
    loop do
      print "\nPlease enter your guess: "
      guess = gets.chomp.downcase
      return guess if Player.guess_valid?(guess)
    end
  end

  def self.guess_valid?(guess)
    (guess.empty? || guess =~ /\d/) ? false : true
  end
end

class Game
  attr_accessor :turns, :secret_word, :letter_used, :hidden_word

  def initialize
    @turns = 9
    @secret_word = Dictionary.pick_word(5, 12)
    @letter_used = []
    play_game
  end

  def display_instructions
    puts "***************************************"
    puts "**** Welcome To The Hangman Game! *****"
    puts "***************************************"
    puts "======================================="
    puts "************ Instructions *************"
    puts "***************************************"
    puts "1. The objective of the game is to guess"
    puts "letters to a secret word. The secret word"
    puts "is represented by a series of horizontal"
    puts "lines indicating its length. "
    puts "For example:"
    puts "If the secret word it 'chess', then it will "
    puts "be displayed as:"
    puts "_ _ _ _ _ \n "
    puts "2. You are given 9 chances. For each incorrect"
    puts "guess, the chances will decrease by 1. For each correct"
    puts "guess, the part of the secret word are revealed"
    puts "For example: If your guess is 's' then the result"
    puts "of the guess will be:"
    puts "_ _ _ s s \n "
    puts "3. When you guessed all the correct letters to the secret word"
    puts "or when you are out of chances, it will be game over."
    puts "4. Any time during the game, if you would like to save"
    puts "your progress, type 'save--' without the quotes"
  end

  def get_guess
    guess = Player.get_guess

    while @letter_used.include?(guess)
      puts "You have already guessed that."
      guess = Player.get_guess
    end

    guess
  end

  def update_letter_used(guess)
    @letter_used << guess
  end

  def display_letter_used
    puts "You tried: #{@letter_used}"
  end

  def check_guess(letter)
    @secret_word.include?(letter) ? display_lines : incorrect_guess
  end

  def display_lines
    # Create horizontal lines
    lines = "".rjust(@secret_word.length, "_")

    @secret_word.split("").each_with_index do |char, i|
      letter_used.each_index do |j|
        if char == letter_used[j]
          # Replace horizontal lines with correct letter
          lines[i] = char
        end
      end
    end

    # Use for checking win condition later
    @hidden_word = lines

    print "\nSecret word: "
    # Add space between each character
    lines.each_char { |c| print lines = "#{c} " }
    puts "\n "
  end

  def play_game
    display_instructions
    display_lines

    loop do
      guess = get_guess
      update_letter_used(guess)
      check_guess(guess)
      display_letter_used if @turns != 0 && !player_won?

      break if game_ended?
    end
  end

  def game_ended?
    if @turns == 0
      puts "Game Over! You have ran out of guesses"
      puts "The secret word was #{@secret_word}"
      true
    elsif player_won?
      puts "Congratulation you have won! You guessed the secret word"
      true
    end
  end

  def player_won?
    @secret_word == @hidden_word
  end

  def incorrect_guess
    @turns -= 1
    Hangman.draw_hangman(@turns)
    display_lines
    puts "You have #{turns} incorrect guesses remaining" if @turns != 0
  end
end

newGame = Game.new
