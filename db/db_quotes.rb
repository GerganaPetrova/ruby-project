require 'sequel'
DB = Sequel.sqlite "db.sqlite"

DB.create_table :quotes do
  primary_key :id
  foreign_key(:book_id, :books)
  foreign_key(:user_id, :users)
  String :text
end

