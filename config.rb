require 'thread'
# require 'fsevent'
require 'rb-fsevent'
require 'highline/import'
require 'atomic-parsley-ruby'

require './movie_extensions'
require './search'
require './dvd'
require './movie'

@api_key = "867c178725a7e646a0f108ee78781a49"
WORKING_DIR = "/Users/mnichols/Movies/Ripping"
DEST_DIR = "/Users/mnichols/Movies/Ripped"
POSTER_PATH = "./Posters"
DISTANCE_THRESHOLD = 0.2

Tmdb::Api.key(@api_key)
