require 'yaml'

class Gpgenv
  class Profile
    attr_reader :file, :name
    def initialize(file, name)
      @file = file
      @name = name
    end

    def exec_command(cmd)
      exec(read_files, cmd)
    end

    private

    def read_files
      hash = {}
      gpgenvs.each do |gpgenv|
        hash.merge!(gpgenv.read_files)  
      end
      hash
    end

    def gpgenvs
      fail(".gpgenvrc file does not exist") unless File.exist?(file)
      yaml = YAML.load(File.read(file))
      fail("Invalid .gpgenvrc file") unless yaml.is_a?(Hash)
      value = yaml[name]

      fail("No such profile: #{name} in .gpgenvrc") unless value
      fail("Invalid .gpgenvrc file") if !value.is_a?(Array) 

      value.map{ |dir| Gpgenv.new(dir: dir) } 
    rescue Psych::SyntaxError => e
      fail("Malformed .gpgenvrc file: #{e.message}")
    end 

  end
end
