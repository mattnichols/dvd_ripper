require './search_imdb'
require './search_tmdb'

class SearchFactory
  def self.get(name)
    return SearchImdb.new if name == 'imdb'
    return SearchTmdb.new if name == 'tmdb'
    raise "Invalid Search Engine Name"
  end
end