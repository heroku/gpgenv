require "gpgenv/version"
require 'gpgenv/config'
require 'gpgenv/error'

module Gpgenv
  def self.read_files(directories)

    # Prefix relative paths that don't exist with gpgenv_home directory, if it is set.
    if Config.gpgenv_home
      directories = directories.map do |d|
        if File.directory?(d)
          d
        else
          gpgenv_dir = "#{Config.gpgenv_home}/#{d}"
          if File.directory?(gpgenv_dir)
            gpgenv_dir 
          else
            d
          end
        end
      end
    end

    # Validate existence of directories
    directories.each do |d|
      raise Error.new("#{d} does not exist.") unless File.exists?(d)
      raise Error.new("#{d} is not a directory.") unless File.directory?(d)
    end

    hash = {}
    directories.each do |dir|
      Dir.glob("#{dir}/*").reject{|f| File.directory? f }.each do |f|
        ext = File.extname(f)
        var = File.basename(f, ext)
        if ext == '.gpg' 
          data = `gpg --batch --quiet --decrypt #{f}`
          raise Error.new("Decrypting #{f} failed.") unless $?.success?
        else
          data = File.read(f)
        end
        hash[var] = data.rstrip
      end
    end

    hash
  end
end
