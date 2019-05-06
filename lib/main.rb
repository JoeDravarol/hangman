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

      puts hangman_parts[part]
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
