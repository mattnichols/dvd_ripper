module DvdRipper
  class Client
    class DvdDetected < StandardError
    end

    def initialize
      @command = nil
      @title = nil
      @last_volume = ''
      @dvd = Dvd.new
      @config = ::DvdRipper::Config.instance
    end

    def process_dvd
      puts
      puts '--------------------------------------------------------------'
      puts "-- Volume: #{@dvd.volume}"
      puts "-- Title: #{@dvd.title}"
      puts '--------------------------------------------------------------'
      puts

      searcher = Search.new
      movie = searcher.closest(@title || @dvd.title)
      if movie.nil?
        puts '- Provide details for movie -'
        puts 'Enter Movie Title:'
        movie = ::Movie.new
        movie.title = $stdin.gets
        puts 'Enter Movie Year:'
        movie.release_date = "#{$stdin.gets.chomp}-01-01"
      end
      title = "#{movie.title} (#{movie.year})"
      output = File.join(@config.working_dir, "#{title.gsub(': ', ' - ').gsub(':', ' - ')}.m4v")
      puts
      puts '--------------------------------------------------------------'
      puts "-- Title: #{movie.title}"
      puts "-- Year: #{movie.year}"
      puts '--------------------------------------------------------------'
      puts
      puts 'Continue? (y/n) |y|'
      continue = $stdin.gets.strip
      continue = 'y' if continue.blank?
      return if continue != 'y'

      @dvd.rip(output)

      movie.tag(output) unless movie.nil?

      puts "\"#{output}\" complete"
      @dvd.eject
      FileUtils.mv(output, @config.dest_dir)
    end

    def force_user_input(input)
      @command = input
      @user_command.raise(DvdDetected, 'DVD Detected')
    end

    def start
      Tmdb::Api.key(@config.tmdb_api_key)

      @user_command = Thread.new do
        loop do
          begin
            if @command.nil?
              puts 'Choose command [(r)ip, (s)pecify title, (q)uit, (e)ject] or insert a DVD'
              @command = $stdin.gets.chomp
            end
            sleep 1
          rescue DvdDetected
            next
          rescue StandardError => e
            puts e.class
            puts e.message
          end
        end
      end

      fsevent = FSEvent.new
      fsevent.watch %w(/Volumes) do |_directories|
        if @command.nil? && @dvd.present? && (@last_volume != @dvd.volume)
          force_user_input('r')
          @last_volume = @dvd.volume
        end
      end

      Signal.trap('INT') do
        fsevent.stop
        Kernel.exit(0)
      end

      message_thread = Thread.new do
        loop do
          begin
            sleep 1 while @command.nil?
            process_dvd if @command == 'r'
            if @command == 's'
              puts 'Enter title:'
              @title = $stdin.gets
              process_dvd
            end
            if @command == 'q'
              puts 'Quitting...'
              fsevent.stop
              break
            end
            @dvd.eject if @command == 'e'
          rescue StandardError => e
            puts e.message
            puts e.class
            puts e.backtrace
          ensure
            @command = nil
            @title = nil
          end
        end
      end

      fsevent.run

      message_thread.kill
      message_thread.join

      @user_command.kill
      @user_command.join
    end
  end
end
