require "sinatra"

require "sinatra/reloader"
require "./hangman.rb"



get "/" do
	word = Board.choose_word
		
	erb :index, :locals => { :word => word }
end