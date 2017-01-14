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
        hash.merge(gpgenv.read_files)  
      end
      hash
    end

    def gpgenvs
      fail(".gpgenvrc file does not exist") unless File.exist?(file)
      yaml = YAML.load(File.read(file))

      fail("Malformed .gpgenvrc file") unless yaml.is_a?(Hash)
      value = yaml[name]

      if value 
        fail("Malformed .gpgenvrc file") if !value.is_a?(Array) 
        value.map{ |dir| Gpgenv.new(dir: dir) } 
      else
        fail("No such profile: #{name} in .gpgenvrc")
      end
    rescue Psych::SyntaxError => e
      fail("Invalid .gpgenvrc file: #{e.message}")
    end 

  end
end
