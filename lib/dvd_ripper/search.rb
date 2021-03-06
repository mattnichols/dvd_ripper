class Search
  def closest(title)
    searcher = SearchFactory.get('tmdb')

    movies = leven_sort(title, searcher.search(title))
    while movies.empty?
      puts ' - Title Not Found - '
      puts 'Enter movie title (or enter to skip search):'
      title = $stdin.gets.chomp
      return nil if title.empty?
      movies = leven_sort(title, searcher.search(title))
    end

    movie = auto_select(movies)
    if movie.nil? || ambiguous?(movies)
      puts 'Please choose:'
      movies.each_with_index do |m, i|
        puts "#{i}. #{m.title} (#{m.release_date}) (#{m.title_distance.round(3)})"
      end
      puts 's. Skip'
      title_sel = $stdin.gets.chomp
      return nil if title_sel == 's'
      movie = movies[title_sel.to_i]
    end
    info = SearchFactory.get('imdb').search(title)[0]

    movie = Movie.new(movie, info)
    movie
  end

  def leven_sort(search_title, movies)
    movies.each do |movie|
      distance = Levenshtein.normalized_distance(search_title, movie.title)
      movie.title_distance = distance
    end
    movies.reverse.sort_by(&:title_distance)
  end

  def auto_select(movies)
    auto_select_distance = ::DvdRipper::Config.instance.distance_threshold
    unless movies.empty?
      return movies[0] if movies.size == 1
      return movies[0] if movies[0].title_distance < auto_select_distance
    end

    nil
  end

  def ambiguous?(movies)
    return true if movies.empty?
    return false if movies.size == 1

    lowest_distance = movies[0].title_distance

    return true if lowest_distance > ::DvdRipper::Config.instance.distance_threshold
    return true if movies.find_all { |m| m.title_distance == lowest_distance }.size > 1

    false
  end
end
