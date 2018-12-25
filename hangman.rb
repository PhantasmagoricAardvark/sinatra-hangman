require "yaml"

class Board
	@@board = ""
	@@secret_word = ""
	@@incorrect_guesses = []
	def self.choose_word
		lines = File.readlines("5desk.txt")
		new_lines = lines.map { |e| e.chomp }
		new_lines.select! {|e| e.length >= 5 && e.length <= 12}
		@@secret_word = new_lines.sample.downcase
	end

	def create_board
		(@@secret_word.length).times do |e|
			@@board += "_"
		end
	end	

	def self.display_board
		if @@board.kind_of?(String)
			board = @@board.split("").join(" ") 
			return "current board: #{board}", "incorrect guesses: #{@@incorrect_guesses.join(" ")}"
		elsif @@board.kind_of?(Array)
			board = @@board.join(" ")
			return "current board: #{board}", "incorrect guesses: #{@@incorrect_guesses.join(" ")}"
		end
	end

	def self.modify_board(guess)
		puts
		i = 0 
		guesses = []
		@@secret_word_arr = @@secret_word.split("")
		if @@board.kind_of?(String) 
			@@board_arr = @@board.split("")
		else
			@@board_arr = @@board
		end
		while i < @@secret_word_arr.length
			if @@secret_word_arr[i] == guess
				guesses << i
			end
			i += 1
		end

		guesses.each{ |e| 
			@@board_arr.insert(e,guess)
			@@board_arr.delete_at(e + 1)
		} 
		@@board = @@board_arr	
	end	

	def self.check_player_guess(guess)
		if @@secret_word.include?(guess)
			Board.modify_board(guess)
		else
			@@incorrect_guesses << guess
		end		 
	end

	def check_victory
		if @@board.kind_of?(Array)
			if @@board.join("") == @@secret_word
				return true
			else
				return false
			end
		else 
			return false
		end
	end

	def self.secret_word
		@@secret_word
	end

	def self.board
		@@board
	end

	def self.incorrect_guesses
		@@incorrect_guesses
	end

	def self.set_secret_word(word)
		@@secret_word = word
	end

	def self.set_board(board)
		@@board = board
	end

	def self.set_incorrect_guesses(arr)
		@@incorrect_guesses = arr
	end
end

class Player
	def guess_letter(turn)
		puts "Give me a letter! or save"
		letter = gets.chomp.downcase
		if letter == "save"
			puts "name the file."
			file_name = gets.chomp.downcase
			File.open("#{file_name}.yaml", "w") { |file|  
				file.puts(Moderator.to_yaml(turn))}
		end
		until !letter.match(/[a-z]|[A-Z]/).nil? && letter.length == 1
			puts "Give me a letter!"
			letter = gets.chomp.downcase
		end
		Board.check_player_guess(letter)
	end	
end



class Moderator
	def self.play_game
		board = Board.new
		player = Player.new
		"Open saved game? y/n"
		Moderator.from_yaml if choice == "y"
		i = 12
		board.choose_word
		board.create_board
		while i > 0
		 
			"Turn #{i}"
			Board.display_board
			player.guess_letter(i)
			if board.check_victory
				Board.display_board
				"You guessed the word! You win!"
				exit
			end
			i -= 1
		end
		"You lose! HAHHAHAAA!!"
		"The word was #{Board.secret_word}"
	end	

	def self.to_yaml(turn)
		YAML.dump ({
			:board => Board.board,
			:secret_word => Board.secret_word,
			:incorrect_guesses => Board.incorrect_guesses,
			:turn => turn
		})
	end

	def self.from_yaml
		puts "Files to load from: #{Dir.glob("*.yaml").each{|a| a.slice!(-5..-1)}}"
		file = gets.chomp
		data = YAML.load(File.open("#{file}.yaml", "r"))
		Moderator.play_saved_game(data)
	end	

	def self.play_saved_game(data)
		i = data[:turn]
		Board.set_secret_word(data[:secret_word])
		Board.set_board(data[:board])
		Board.set_incorrect_guesses(data[:incorrect_guesses])
		board = Board.new
		player = Player.new
		while i > 0
			puts 
			puts "Turn #{i}"
			Board.display_board
			player.guess_letter(i)
			if board.check_victory
				puts Board.display_board
				puts "You guessed the word! You win!"
				exit
			end
			i -= 1
		end
		puts "You lose! HAHHAHAAA!!"
		puts "The word was #{Board.secret_word}"
	end
end

class Sinatra1
	@@board = ""
	@@secret_word = ""
	@@incorrect_guesses = []

	def choose_secret_word 
		lines = File.readlines("5desk.txt")
		new_lines = lines.map { |e| e.chomp }
		new_lines.select! {|e| e.length >= 5 && e.length <= 12}
		@@secret_word = new_lines.sample.downcase
	end

	def create_board(word)
		(word.length).times do |e|
			@@board += "_"
		end
	end

	def display_board
		puts @@board
		if @@board.kind_of?(String)
			board = @@board.split("").join(" ") 
			return "current board: #{board}", @@board
		elsif @@board.kind_of?(Array)
			board = @@board.join(" ")
			return "current board: #{board}", @@board
		end
	end

end	
