require 'sequel'
DB = Sequel.sqlite "db.sqlite"

DB.alter_table :users do
   add_column :email, :string,
   add_column :name, :string
end
