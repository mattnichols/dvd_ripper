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

    system("HandBrakeCLI -Z \"AppleTV 3\" --main-feature -i \"#{volume}\" -o \"#{output}\"")
    exit_code =  $?
    if exit_code.exitstatus != 0
      `killall HandBrakeCLI`
      Kernel.exit(exit_code.exitstatus)
    end
  end
  
  def eject
    `drutil tray eject`
  end
end