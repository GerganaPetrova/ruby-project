require 'sinatra'
require "./models/book"

get '/' do
  erb :index, locals: {baba: 'My strinka' }
end

get '/books' do
  @books = [
    Book.new('50 shades of penis', 'Pencho'),
    Book.new('Testicule cancer', 'EDRRtg')
  ]

  erb :books
end

