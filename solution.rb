require 'sinatra'
require 'sinatra/json'
require 'google_translate'
require 'pony'
require "./models/book"
require "./models/user"
require "./models/quote"
require "./models/review"
enable :sessions
enable :logging
set :session_secret, 'super secret'

get '/' do
  @quotes = Quote.all
  erb :index
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.authenticate(params[:username], params[:password])
  if not user
    erb :login, locals: {:login_fail => true}
    redirect '/login'
  else
    session[:user] = user
    redirect '/'
  end
end

get '/logout' do
  session.delete :user
  redirect '/'
end

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.create(params)
  if user.valid?
    user.save
    user.send_mail(params)
    redirect '/'
  else
    p "Sign failed..."
    redirect '/signup'
  end
end

get '/books' do
  @books = Book.where :user_id => session[:user].id
  erb :books
end

get'/book/:id' do
  @book = Book.find :id => params[:id]
  @page = 1
  erb :book
end

get '/book/:book_id/:page' do
  @book = Book.find :id => params[:book_id]
  @page = params[:page].to_i
  erb :book
end

get '/quotes' do
   @quotes = Quote.where :user_id => session[:user].id
   erb :quotes
end

post '/quote' do
  quote = Quote.create(:user_id => session[:user].id, :book_id => params[:book_id], :text => params[:quote_text])
  quote.save
  json success: true
end

get '/reviews' do
  @reviews = Review.where :user_id => session[:user].id
  erb :reviews
end

post '/review' do
  review = Review.create(:book_id => params[:book_id], :user_id => session[:user].id, :text => params[:text])
  review.save
  json success: true
end

get '/translate' do
  translator = Google::Translator.new
  translator.translate(:en, :bg, params[:text])[0]
end

get '/upload' do
  erb :upload
end

post '/upload' do
  text = params[:book][:tempfile].read
  book = Book.create(:user_id => session[:user].id, :text => text, :author => params[:author], :title => params[:title])
  book.save
  redirect '/books'
end
