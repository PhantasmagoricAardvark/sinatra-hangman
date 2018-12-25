require "sinatra"

require "sinatra/reloader"
require "./hangman.rb"

sinatra = Sinatra1.new 
word = sinatra.choose_secret_word

board = sinatra.create_board(word)

display_board = sinatra.display_board

turn = 12 

get "/" do
	turn -= 1
	puts board
		
	erb :index, :locals => { :word => word, :turn => turn, :display_board => display_board }
end