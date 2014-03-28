class SearchTmdb
  def search(title)
    Tmdb::Movie.find(title)
  end
end

class Tmdb::Movie
  include MovieExtensions
end
