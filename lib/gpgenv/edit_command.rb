require 'clamp'
require 'fileutils'
require 'gpgenv'
require 'gpgenv/base_command'
require 'tempfile'
require 'yaml'

class Gpgenv
  class EditCommand < Gpgenv::BaseCommand

    def execute
      env = gpgenv.read_files
      Tempfile.open(['env', '.yaml'], ENV.fetch('TMPDIR', '/tmp')) do |f|
        f.write(env.to_yaml)

        done = false
        new_env = nil
        begin
          # Write out current env to the file, as yaml.
          f.close

          # Run the user's choice of editor on the file, wait until they're done.
          system("#{ENV['EDITOR']} #{f.path}")

          # Reopen the file, return to the start, load yaml from it.
          f.open
          f.rewind

          file_contents = f.read

          begin
            new_env = YAML.load(file_contents)
          rescue Psych::SyntaxError => e
            puts e.message
            STDOUT.write "Invalid yaml file. Try again (y/n)? " 
            fail("Aborted") unless STDIN.gets.downcase.strip == 'y'
            f.rewind
          end

          # Keep looping until we get valid yaml.
        end until new_env

        # Write out yaml to gpgenv.
        ::FileUtils.mkdir_p(gpgenv.dir)
        new_env.each do |key, value|
          gpgenv.set(key, value)
        end

        # Calculate missing keys
        missing_keys = env.keys.select do |k|
          !new_env.keys.include?(k)
        end

        # Delete missing keys.
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

  end

end
