require 'singleton'
require 'yaml'

module DvdRipper
  class Config
    include Singleton

    attr_accessor :config

    DEFAULTS = {
      working_dir: '~/tmp/movies',
      dest_dir: '~/movies',
      poster_dir: '~/tmp/movies/posters',
      distance_threshold: 0.2,
      tmdb_api_key: nil
    }.freeze

    def load
      self.config = DEFAULTS.merge(read_config)
    end

    def read_config
      yml = ''
      yml = File.read(config_path) if exists?

      return YAML.load(yml) unless yml.blank?

      {}
    end

    def exists?
      File.exist?(config_path)
    end

    def working_dir
      config[:working_dir]
    end

    def dest_dir
      config[:dest_dir]
    end

    def tmdb_api_key
      config[:tmdb_api_key]
    end

    def poster_dir
      config[:poster_dir]
    end

    def distance_threshold
      config[:distance_threshold]
    end

    def config_path
      File.expand_path('~/.dvd_ripper')
    end

    def save!
      File.open(config_path, 'w+') do |config_file|
        config_file.write(config.to_yaml)
      end
    end

    def prompt!
      config.each do |k, v|
        puts "#{k} (ENTER: #{v}):"
        new_value = $stdin.gets
        config[k] = new_value.strip unless new_value.strip.blank?
      end

      save!
    end
  end
end

::DvdRipper::Config.instance.load

# WORKING_DIR = "/Users/mnichols/Movies/Ripping"
# DEST_DIR = "/Users/mnichols/Movies/Ripped"
# POSTER_PATH = "./Posters"
# DISTANCE_THRESHOLD = 0.2

#     @api_key = "867c178725a7e646a0f108ee78781a49"
