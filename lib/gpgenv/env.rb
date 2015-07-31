require 'gpgenv/error'

module Gpgenv
  module Env

    def self.read_files(directories)
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
end
