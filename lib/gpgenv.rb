require "gpgenv/version"
require 'gpgenv/error'
require 'shellwords'

module Gpgenv

  def self.read_files
    hash = {}

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

  def self.set(key, value)
    system "echo #{Shellwords.shellescape(value)} | gpg --batch --yes -e -r #{key_id} -o #{dir}/#{key}.gpg"
  end

  def self.exec_command(cmd)
    exec(read_files, cmd)
  end

  def self.dir
    "#{Dir.pwd}/.gpgenv"
  end

  def self.key_id
    ENV['GPGENV_KEY_ID'] || fail("GPGENV_KEY_ID must be set.")
  end
end
