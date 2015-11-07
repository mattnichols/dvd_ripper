class SearchTmdb
  def search(title)
    Tmdb::Movie.find(title)
  end
end

module Tmdb
  class Movie
    include MovieExtensions
  end
end
