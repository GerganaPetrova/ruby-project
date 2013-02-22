require 'sequel'
DB = Sequel.sqlite "db.sqlite"

DB.create_table :books do
  primary_key :id
  foreign_key(:user_id, :users)
  String :text
  String :author
  String :title
end
