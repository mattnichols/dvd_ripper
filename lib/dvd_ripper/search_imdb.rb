class SearchImdb
  def search(title)
    Imdb::Search.new(title).movies
  end
end

class Imdb::Movie
  include MovieExtensions
end
