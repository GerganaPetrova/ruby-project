# encoding: UTF-8
require 'sinatra'
require 'rack/test'

set :environment, :test
include Rack::Test::Methods

def app
  Sinatra::Application
end

def do_login
  post '/login', { :username => 'bigsmile1', :password => 'asd' }
end

describe 'Users' do
  it 'can create user' do
    post '/signup', { :name => 'Gergana Petrova', :email => 'gergana.petrova.petrova@gmail.com',
                      :username => 'my_testuser', :password => 'testpassword'}
    last_response.should be_redirect
    last_response.location.should end_with '/'
  end

  it 'can login user' do
    post '/login', { :username => 'bigsmile1', :password => 'asd'}
    last_response.should be_redirect
    last_response.location.should end_with '/'
  end

  it 'can logout user' do
    do_login
    get '/logout'
    last_response.should be_redirect
    last_response.location.should end_with '/'
  end

  after(:all) do
    user = User.find(:username => 'my_testuser')
    user.delete
  end
end

describe 'Books' do
  before(:all) do
    do_login
  end

  it 'can upload book' do
    post '/upload',{ :book => Rack::Test::UploadedFile.new("/home/badwolf/asd.txt","text/plain"), :author => "baba", :title => "dqdo" }
    last_response.should be_redirect
    last_response.location.should end_with '/books'
  end

  it 'can give book lists' do
    get '/books'
    user = User.find :username => 'bigsmile1'
    user.books.each { |book| last_response.body.should include book.title }
  end

  after(:all) do
    book = Book.find(:author => "baba", :title => "dqdo")
    book.delete
  end
end

describe 'Quotes' do
  before(:all) do
    do_login
  end

  it 'can give user quotes' do
    get '/quotes'
    quotes = Quote.where :user_id => 31
    quotes.each { |quote| last_response.body.should include quote.text }
  end
end

describe 'Reviews' do
  before(:all) do
    do_login
  end

  it 'can give user reviews' do
    get '/reviews'
    reviews = Review.where :user_id => 31
    reviews.each { |review| last_response.body.should include review.text }
  end
end


