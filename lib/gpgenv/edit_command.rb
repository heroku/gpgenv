require 'fileutils'
require 'clamp'
require 'gpgenv'
require 'tempfile'


module Gpgenv
  class EditCommand < Clamp::Command

    def execute
      env = Hash[Gpgenv.read_files.map{|k,v| [ k, to_editable(v) ] }]
      Tempfile.open('.env', ENV.fetch('TMPDIR', '/tmp')) do |f|
        env.each do |k,v|
          f.write("#{k}=#{v}\n")
        end

        f.close
        system("#{ENV['EDITOR']} #{f.path}")
        f.open

        f.rewind
        lines = f.read.split("\n")

        ::FileUtils.mkdir_p(Gpgenv.dir)
        lines.each do |line|
          i = line.index('=')
          key = line[0..i-1]
          value = line[i+1..-1]
          Gpgenv.set(key, from_editable(value))
        end
      end
    end

    private

    # Convert string to editable string. If it is a multiline string,
    # enclose it in quotes and replace newlines with \n.
    def to_editable(str)
      if str =~ /\n/
        "#{str.gsub(/\n/, '\n')}"
      else 
        str
      end
    end

    # Convert from editable back to the format to write to the file.
    # Replace literal \n with newines, strip quotes.
    def from_editable(str)
      if str =~ /\\n/
        str.gsub(/\\n/, "\n")
      else
        str
      end
    end

  end
end
