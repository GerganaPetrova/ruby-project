class Book
  attr_reader :title, :author

  def initialize(title, author)
    @title, @author = title, author
  end
end
