require 'fileutils'
require 'clamp'
require 'gpgenv'
require 'gpgenv/base_command'
require 'tempfile'


class Gpgenv
  class EditCommand < Gpgenv::BaseCommand

    def execute
      env = Hash[gpgenv.read_files.map{|k,v| [ k, to_editable(v) ] }]
      Tempfile.open('.env', ENV.fetch('TMPDIR', '/tmp')) do |f|
        env.each do |k,v|
          f.write("#{k}=#{v}\n")
        end

        f.close
        system("#{ENV['EDITOR']} #{f.path}")
        f.open

        f.rewind
        lines = f.read.split("\n")

        ::FileUtils.mkdir_p(gpgenv.dir)
        new_env = {}
        lines.each_with_index do |line, index|
          i = line.index('=')
          fail("Line #{index+1} is invalid") unless i
          key = line[0..i-1]
          value = line[i+1..-1]
          new_env[key] = value
        end

        new_env.each do |key, value|
          gpgenv.set(key, from_editable(value))
        end

        missing_keys = env.keys.select do |k|
          !new_env.keys.include?(k)
        end

        missing_keys.each do |missing_key|
          gpgenv.set(missing_key, nil)
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
