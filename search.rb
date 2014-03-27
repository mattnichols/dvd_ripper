require './search_factory'
require 'levenshtein'

class Search
  def closest(title)
    searcher = SearchFactory.get("tmdb")
    
    movies = leven_sort(title, searcher.search(title))
    while movies.empty?
      puts "Unable to locate title"
      puts "Enter movie title:"
      title = gets.chomp
      movies = leven_sort(title, searcher.search(title))
    end
    
    movie = auto_select(movies)
    if movie.nil? or ambiguous?(movies)
      puts "Please choose:"
      movies.each_with_index do |movie, i|
        puts "#{i}. #{movie.title} (#{movie.release_date}) (#{movie.title_distance.round(3)})"
      end
      title_sel = gets
      movie = movies[title_sel.to_i]
    end
    info = SearchFactory.get("imdb").search(title)[0]
    
    movie = Movie.new(movie, info)
    movie
  end
  
  def leven_sort(search_title, movies)
    movies.each do |movie|
      distance = Levenshtein.normalized_distance(search_title, movie.title)
      movie.title_distance = distance
    end
    movies.reverse.sort_by { |m| m.title_distance }
  end
  
  def auto_select(movies)
    return movies[0] if (not movies.empty?) and (movies[0].title_distance < DISTANCE_THRESHOLD)
    nil
  end
  
  def ambiguous?(movies)
    return true if movies.empty?
    return false if movies.size == 1
    
    lowest_distance = movies[0].title_distance
    
    return true if lowest_distance > DISTANCE_THRESHOLD
    return true if movies.find_all { |m| m.title_distance == lowest_distance }.size > 1
    
    false
  end
end