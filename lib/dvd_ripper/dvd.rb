class Dvd
  attr_accessor :volumes

  def initialize
    @volumes = "/Volumes"
  end

  def volume
    vol = nil
    Dir.entries(@volumes).each do |video_dir|
      if not [".", ".."].member?(video_dir)
        full_path = File.join(@volumes, video_dir)
        if Dir.exists?(File.join(full_path, "VIDEO_TS"))
          vol = full_path
          break
        end
      end
    end
    vol
  end

  def title
    raise "Invalid DVD Root or DVD not mounted at #{@volumes}" if not present?
    File.basename(volume).gsub("_", " ").capitalize
  end

  def present?
    !volume.nil?
  end

  def rip(output)
    File.delete(output) if File.exists?(output)

    state = :scanning
    percent = "0.0"
    eta = "unknown"
    dc = 0
    spinner = ["-", "\\", "|", "/"]

    encoding_reg = /Encoding: task \d+ of \d+, (?<percent>\d+\.\d+) %.*ETA (?<eta>\d{2}h\d{2}m\d{2}s)/i
    status_update = Thread.new do
      while true do
        sleep(1)
        dc = dc + 1

        if state == :encoding
          print "\r#{spinner[dc%4]} Encoding #{percent} % (time left #{eta})"
        end

        if state == :scanning
          print("\r" + (" " * 50)) if ((dc % 20) == 0)
          print "\r#{spinner[dc%4]} Scanning Titles.#{"." * (dc % 20)}"
        end
      end
    end

    command_output = []
    last_line = nil
    File.open("./encode.log", "w+") do |log|
      IO.popen("HandBrakeCLI -Z \"AppleTV 3\" --main-feature -i \"#{volume}\" -o \"#{output}\" 2>&1", "w+") do |f|
        begin
          while buf = f.read(255)
            lines = buf.split(/\r|\n/)
            lines.compact!

            if (lines.size > 1) and (not last_line.nil?)
              command_output << last_line + lines.shift
            end

            if buf[-1] == "\r" or buf[-1] == "\n"
              last_line = nil
            else
              last_line = lines.pop
            end

            command_output << lines
            command_output.flatten!

            while ln = command_output.shift
              ln = ln.strip unless ln.nil?

              # Change to encoding as soon as a matching line is found
              if encoding_reg =~ ln
                state = :encoding
              end

              if state == :encoding
                if m = encoding_reg.match(ln)
                  percent = m[:percent]
                  eta = m[:eta]
                end
              end

              log.write "#{state}:#{percent}:#{eta} - #{ln}\n"
            end
            command_output = []
          end
        rescue Exception => e
          puts e.message
          puts e.class
          puts e.backtrace
        end
      end
    end
    exit_code =  $?

    if exit_code.exitstatus != 0
      `killall HandBrakeCLI`
      puts "Encoding Failed. See encode.log"
    end
  ensure
    status_update.kill
    status_update.join
  end

  def eject
    system("drutil tray eject")
  end
end
