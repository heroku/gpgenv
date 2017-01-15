require "gpgenv/version"
require 'gpgenv/error'
require 'shellwords'

class Gpgenv

  attr_reader :dir

  def initialize(dir:)
    @dir = dir
  end

  def read_files
    hash = {}

    fail("#{dir} does not exist.") unless File.exist?(dir)
    fail("#{dir} is not a directory.") unless File.directory?(dir)

    Dir.glob("#{dir}/*.gpg").each do |f|
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
    hash
  end

  def set(key, value)
    if value.nil?
      File.delete("#{dir}/#{key}.gpg")
    else
      system "echo #{Shellwords.shellescape(value)} | gpg --batch --yes -e -r #{key_id} -o #{dir}/#{key}.gpg"
    end
  end

  def exec_command(cmd)
    exec(read_files, cmd)
  end

  def key_id
    ENV['GPGENV_KEY_ID'] || fail("GPGENV_KEY_ID must be set.")
  end

end
