require "sinatra"
require "sinatra/reloader"
require "./hangman.rb"

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

	def self.display_board
		if @@board.kind_of?(String)
			board = @@board.split("").join(" ") 
			return "current board: #{board}"
		elsif @@board.kind_of?(Array)
			board = @@board.join(" ")
			return "current board: #{board}"
		end
	end

	def modify_board(guess)
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

		guesses.each { |e| 
			@@board_arr.insert(e,guess)
			@@board_arr.delete_at(e + 1)
		} 
		@@board = @@board_arr	
		return @@board
	end	

end	

sinatra = Sinatra1.new 
secret_word = sinatra.choose_secret_word

board = sinatra.create_board(secret_word)


turn = 12 




get "/" do
	turn -= 1
	letter = params["letter"]


	sinatra.modify_board(letter)
	erb :index, :locals => { :secret_word => secret_word, :turn => turn }
end


