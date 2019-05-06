# 3. Draw out hangman stickfigure: save each body parts to a variable
# 4. Get user inputs
# 5. Push each 'letter' guess into an array
# 6. Have a turns/lives to keep track of how many incorrect guesses the player has
# 7. Once the game is working. Work on the save and load data. (Yaml, JSON)

class Dictionary
  @@dictionary = File.readlines("5desk.txt")

  def self.pick_word(min_char_length, max_char_length)
    loop do
      word = @@dictionary[rand(@@dictionary.length)].gsub("\n", "")

      return word.downcase if word.length >= min_char_length && word.length <= max_char_length
    end
  end
end
