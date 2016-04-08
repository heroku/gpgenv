require 'fileutils'
require 'clamp'
require 'gpgenv'
require 'tempfile'


module Gpgenv
  class EditCommand < Clamp::Command

    def execute
      env = Gpgenv.read_files
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
          Gpgenv.set(key, value)
        end
      end
    end

  end
end
