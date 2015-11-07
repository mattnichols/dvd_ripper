class SearchFactory
  def self.get(name)
    return SearchImdb.new if name == 'imdb'
    return SearchTmdb.new if name == 'tmdb'
    fail 'Invalid Search Engine Name'
  end
end
