require "sinatra"
require "sinatra/reloader" if development?
require "./hangman.rb"

class Sinatra1
	@@board = ""
	@@secret_word = ""
	@@incorrect_guesses = []
	@@turn = 12

	def self.choose_secret_word 
		lines = File.readlines("5desk.txt")
		new_lines = lines.map { |e| e.chomp }
		new_lines.select! {|e| e.length >= 5 && e.length <= 12}
		@@secret_word = new_lines.sample.downcase
	end

	def self.create_board(word)
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

	def self.modify_board(guess)
		if @@secret_word.include?(guess.to_s)
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
		else
			@@incorrect_guesses << guess
		end
	end	

	def self.reset
		@@board = ""
		@@secret_word = ""
		@@incorrect_guesses = []
		secret_word = Sinatra1.choose_secret_word
		Sinatra1.create_board(secret_word)		
	end

	def self.check_victory
		if @@board.kind_of?(Array)
			if @@board.join("") == @@secret_word
				@@turn = 12
				true
			else
				return false
			end
		else 
			return false
		end
	end

	def self.reduce_turn
		@@turn -= 1
	end

	def self.check_turn
		if @@turn == 0
			Sinatra1.reset
			@@turn = 12
		end	
	end


	def self.turn
		@@turn
	end

	def self.secret_word
		@@secret_word
	end	

	def self.incorrect_guesses
		@@incorrect_guesses.join(" ")
	end

end	

secret_word = Sinatra1.choose_secret_word
board = Sinatra1.create_board(secret_word)





get "/" do
	letter = params["letter"]
	Sinatra1.modify_board(letter)

	Sinatra1.check_turn
	

	turn = Sinatra1.turn
	erb :index, :locals => { :turn => turn }

end
