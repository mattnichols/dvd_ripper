module DvdRipper
  class MovieTitle
    attr_reader :basename, :filename, :title, :year

    def initialize(filename)
      title_parser = /\A(?<title>[\S\s]+)\s?\(\s?(?<year>[0-9]+)\s?\)\z/i

      @filename = filename.strip
      @basename = ::File.basename(filename, ".*").strip

      matches = title_parser.match(@basename.squeeze(" "))
      @title = matches[:title].strip
      @year = matches[:year].strip
    end
  end
end
