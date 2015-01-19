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

	adjectives = []
	descriptors = []
	subjects = []

	if File.exists? "./txt/adjectives.txt"
		file = File.open("./txt/adjectives.txt")
		file.each_line { |line| adjectives << line.strip }
	end

	if File.exists? "./txt/descriptors.txt"
		file = File.open("./txt/descriptors.txt")
		file.each_line { |line| descriptors << line.strip }
	end

	if File.exists? "./txt/subjects.txt"
		file = File.open("./txt/subjects.txt")
		file.each_line { |line| subjects << line.strip }
	end

	get '/' do
		@urls = DB[:urls].all
		erb :index
	end

	get '/shorten' do
		erb :shorten
	end

	post '/shorten' do
		DB[:urls].insert(shortened: shorten_url(adjectives,descriptors,subjects), original: params[:url])
		redirect '/'
	end

	def shorten_url (adjectives, descriptors, subjects)
		adjective = adjectives[rand(adjectives.size)]
		descriptor = descriptors[rand(descriptors.size)]
		subject = subjects[rand(subjects.size)]
		shinyme_url = "http://shinyme.me/"
		shortened_url = shinyme_url+adjective+descriptor+subject
		shortened_url.gsub(/\s+/, "")
		shortened_url
	end
end