require 'sinatra'

class Shinymeme < Sinatra::Application
	get '/' do
		erb :index
	end

	get '/shorten' do
		erb :shorten
	end
end