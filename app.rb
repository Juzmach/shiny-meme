require 'sinatra'
require 'sequel'
require './config/fileutils'

class Shinymeme < Sinatra::Application

	DB = Sequel.sqlite

    enable :sessions
    set :session_secret, 'twigs and plums'

	unless DB.table_exists? :urls
		DB.create_table :urls do
			primary_key :id
			String :shortened_id
			String :original
            String :shortened_url
		end
	end

    class URL < Sequel::Model; end

	adjectives = Fileutils.load_file('./txt/adjectives.txt')
	descriptors = Fileutils.load_file('./txt/descriptors.txt')
	subjects = Fileutils.load_file('./txt/subjectives.txt')

	get '/' do
        erb :index
	end

    get '/:shortened_id' do 
        url = DB[:urls][shortened_id: params[:shortened_id]]
        
        unless url.nil?
            redirect url[:original], 301
        end
            not_found
    end

	post '/shorten' do
		# DB[:urls].insert(shortened: shorten_url(adjectives,descriptors,subjects), original: params[:url])
        shortened = shorten_url(adjectives,descriptors,subjects)
        shortened_url = 'http://shinyme.me/' + shortened
        session[:url] = URL.create(shortened_id: shortened, original: params[:url], shortened_url: shortened_url)
        redirect '/'
	end

	def shorten_url (adjectives, descriptors, subjects)
		adjective = adjectives[rand(adjectives.size)]
		descriptor = descriptors[rand(descriptors.size)]
		subject = subjects[rand(subjects.size)]
		shortened_url = adjective+descriptor+subject
		shortened_url.gsub(/\s+/, "")
		shortened_url
	end

    not_found do
        status 404
        erb :oops
    end
end
