require 'sequel'
Sequel::Model.db = Sequel.sqlite './db/db.sqlite'

class Book < Sequel::Model
 many_to_one :user

  def page(number)
    page = self[:text].split(/\n+/).each_slice(25).to_a
    page[number-1]
  end
end
