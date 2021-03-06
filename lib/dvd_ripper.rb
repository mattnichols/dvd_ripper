require 'dvd_ripper/version'

require 'thread'
require 'rb-fsevent'
require 'atomic-parsley-ruby'
require 'fileutils'
require 'io/console'
require 'imdb'
require 'themoviedb'
require 'levenshtein'

require_relative 'dvd_ripper/movie_stub.rb'
require_relative 'dvd_ripper/movie_title.rb'
require_relative 'dvd_ripper/movie_extensions.rb'
require_relative 'dvd_ripper/search_factory.rb'
require_relative 'dvd_ripper/search_imdb.rb'
require_relative 'dvd_ripper/search_tmdb.rb'
require_relative 'dvd_ripper/search.rb'
require_relative 'dvd_ripper/dvd.rb'
require_relative 'dvd_ripper/movie.rb'
require_relative 'dvd_ripper/config.rb'
require_relative 'dvd_ripper/client.rb'
