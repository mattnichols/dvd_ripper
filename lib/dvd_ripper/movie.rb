class Movie
  extend Forwardable

  def initialize(tmdb_info = nil, imdb_info = nil)
    @tmdb_info = tmdb_info.nil? ? ::MovieStub.new : tmdb_info
    @imdb_info = imdb_info.nil? ? ::MovieStub.new : imdb_info
  end

  def_delegators :@tmdb_info, :title, :year, :poster_path
  def_delegators :@imdb_info, :plot, :genres, :plot_summary

  require 'open-uri'

  def tag(output)
    poster_file_path = nil
    unless poster_path.nil?
      Dir.mkdir(::DvdRipper::Config.instance.poster_dir) unless Dir.exist?(::DvdRipper::Config.instance.poster_dir)
      poster_file_path = File.expand_path(File.join(::DvdRipper::Config.instance.poster_dir, poster_path))
      poster = File.open(poster_file_path, 'wb')
      begin
        open("http://image.tmdb.org/t/p/w500#{poster_path}", 'rb') do |download|
          poster.write(download.read)
        end
      ensure
        poster.close
      end
    end

    # Remove stik and other artwork, just in case
    v = AtomicParsleyRuby::Media.new(output)
    v.artwork 'REMOVE_ALL'
    v.stik 'remove'
    v.overwrite true
    v.process

    v = AtomicParsleyRuby::Media.new(output)
    v.overwrite true
    v.title title
    v.comment plot unless plot.nil?
    v.description plot unless plot.nil?
    v.year year.to_s
    v.stik '0'
    v.genre genres[0]
    v.longdesc plot_summary unless plot_summary.nil?
    v.artwork poster_file_path unless poster_file_path.nil?
    v.process

    # m = MiniExiftool.new output
    # m["director"] = info.director

    # Need to use mp4v2 lib extensions to write this stuff
    # m["directors//name"] = "Bob"
    # m["producers//name"] = "George"
    # m["screenwriters//name"] = "Writers"
    # m["studio//name"] = "Studio C"
    # m.save
  end
end
