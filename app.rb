require 'sinatra'

class Shinymeme < Sinatra::Application
	get '/' do
		"hello world!"
	end

	get '/shorten' do
		"shortened url!"
	end
end