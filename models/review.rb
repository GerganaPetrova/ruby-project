require 'sequel'
Sequel::Model.db = Sequel.sqlite './db/db.sqlite'

class Review < Sequel::Model
  many_to_one :user
  many_to_one :book
end
