require 'sinatra'
require 'sequel'

class Shinymeme < Sinatra::Application

	DB = Sequel.sqlite('database.sqlite3')

	unless DB.table_exists? :urls
		DB.create_table :urls do
			primary_key :id
			String :shortened
			String :original
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
		DB[:urls].insert(shortened: shorten_url, original: params[:url])
		redirect '/'
	end

	def shorten_url
		adjective1 = "Overly"
		adjective2 = "Positive"
		subject = "Corgi"
		shinyme_url = "http://shinyme.me/"
		shortened_url = shinyme_url + adjective1 + adjective2 + subject

		shortened_url
	end
end