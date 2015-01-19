require 'sinatra'
require 'sequel'

class Shinymeme < Sinatra::Application

	DB = Sequel.sqlite('database.sqlite3')

	unless DB.table_exists? :urls
		DB.create_table :urls do
			primary_key :id
			String :shortened
			String :url
		end
	end

	get '/' do
		@urls = DB[:urls].all
		erb :index
	end

	get '/shorten' do
		erb :shorten
	end

	post '/shorten' do
		DB[:urls].insert(shortened: shorten_url, url: params[:url])
		redirect '/'
	end

	def shorten_url
		shortened_url = "http://shinyme.me/"

		shortened_url
	end
end