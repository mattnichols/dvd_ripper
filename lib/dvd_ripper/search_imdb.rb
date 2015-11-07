class SearchImdb
  def search(title)
    Imdb::Search.new(title).movies
  end
end

module Imdb
  class Movie
    include MovieExtensions
  end
end
