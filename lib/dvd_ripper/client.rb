module DvdRipper
  class Client
    def initialize
      @command = nil
      @title = nil
      @last_volume = ""
      @dvd = Dvd.new
    end

    def process_dvd
      puts
      puts "--------------------------------------------------------------"
      puts "-- Volume: #{@dvd.volume}"
      puts "-- Title: #{@dvd.title}"
      puts "--------------------------------------------------------------"
      puts

      searcher = Search.new
      movie = searcher.closest(@title || @dvd.title)
      if movie.nil?
        puts "- Provide details for movie -"
        puts "Enter Movie Title:"
        movie = ::Movie.new
        movie.title = $stdin.gets
        puts "Enter Movie Year:"
        movie.release_date = "#{$stdin.gets.chomp}-01-01"
      end
      title = "#{movie.title} (#{movie.year})"
      output = File.join(::DvdRipper::Config.instance.working_dir, "#{title.gsub(": ", " - ").gsub(":", " - ")}.m4v")
      puts
      puts "--------------------------------------------------------------"
      puts "-- Title: #{movie.title}"
      puts "-- Year: #{movie.year}"
      puts "--------------------------------------------------------------"
      puts
      puts "Continue? (y/n) |y|"
      continue = $stdin.gets.strip
      continue = 'y' if continue.blank?
      if continue != 'y'
        return
      end

      @dvd.rip(output)

      movie.tag(output) unless movie.nil?

      puts "\"#{output}\" complete"
      @dvd.eject
      FileUtils.mv(output, ::DvdRipper::Config.instance.dest_dir)
    end

    def force_user_input(input)
      @command = input
      @user_command.raise("wakeup")
    end

    def start
      Tmdb::Api.key(::DvdRipper::Config.instance.tmdb_api_key)

      @user_command = Thread.new do
        while true
          begin
            if @command.nil?
              puts "Choose command [(r)ip, (s)pecify title, (q)uit, (e)ject] or insert a DVD"
              @command = $stdin.gets.chomp
            end
            sleep 1
          rescue Exception => e
            puts e.message
          end
        end
      end

      fsevent = FSEvent.new
      fsevent.watch %W(/Volumes) do |directories|
        if @command.nil? and @dvd.present? and (@last_volume != @dvd.volume)
          force_user_input("r")
          @last_volume = @dvd.volume
        end
      end

      Signal.trap("INT") do
        fsevent.stop
        Kernel.exit(0)
      end

      message_thread = Thread.new do
        while true
          begin
            while @command.nil?
              sleep 1
            end
            if @command == "r"
              process_dvd
            end
            if @command == "s"
              puts "Enter title:"
              @title = $stdin.gets
              process_dvd
            end
            if @command == "q"
              puts "Quitting..."
              fsevent.stop
              break
            end
            if @command == "e"
              @dvd.eject
            end
          rescue Exception => e
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
