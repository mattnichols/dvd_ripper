#!/usr/bin/ruby

require './config.rb'
require 'fileutils'
require 'io/console'

@command = nil
@last_volume = ""
@dvd = Dvd.new

def process_dvd
  puts
  puts "--------------------------------------------------------------"
  puts "-- Volume: #{@dvd.volume}"
  puts "-- Title: #{@dvd.title}"
  puts "--------------------------------------------------------------"
  puts

  searcher = Search.new
  movie = searcher.closest(@dvd.title)
  title = "#{movie.title} (#{movie.year})"
  puts WORKING_DIR
  puts DEST_DIR

  output = File.join(WORKING_DIR, "#{title.gsub(": ", " - ").gsub(":", " - ")}.m4v")
  puts
  puts "--------------------------------------------------------------"
  puts "-- Title: #{movie.title}"
  puts "-- File: #{output}"
  puts "--------------------------------------------------------------"
  puts
  continue = ask("Continue? (y/n)") { |q| q.default = "y" }
  if continue != 'y'
    puts "Aborting..."
    return
  end

  puts
  puts "Ripping..."
  puts
  puts

  @dvd.rip(output)
  movie.tag(output)

  puts
  say "\"#{output}\" complete"
  puts
  puts
  system("drutil tray eject")
  FileUtils.mv(output, DEST_DIR)

  # puts `exiftool "#{output}"`
end

fsevent = FSEvent.new
fsevent.watch %W(/Volumes) do |directories|
  if @command.nil? and @dvd.present? and (@last_volume != @dvd.volume)
    @last_volume = @dvd.volume
    @command = "r"
  end
end

user_command = Thread.new do
  while true
    if @command.nil?
      puts "Enter command (r|q) or insert DVD:"
      @command = STDIN.getch.chomp
    end
    sleep 1
  end
end

Signal.trap("INT") do
  @command = "q"
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
      if @command == "q"
        puts "Quitting..."
        fsevent.stop
        break
      end
    rescue Exception => e
      puts e.message
      puts e.backtrace
    ensure
      @command = nil
    end
  end
end

fsevent.run

message_thread.kill
message_thread.join

user_command.kill
user_command.join

exit 0