require 'gpgenv'
require 'clamp'
require 'gpgenv/edit_command'
require 'gpgenv/exec_command'
require 'gpgenv/export_command'
require 'gpgenv/import_command'
require 'gpgenv/set_command'
require 'gpgenv/shell_command'

class Gpgenv
  class GpgenvCommand < Clamp::Command

    option '--version', :flag, "Print version"

    subcommand 'exec',
      'Execute the given shell command, using .gpgenv env vars',
      Gpgenv::ExecCommand

    subcommand 'edit',
      'Use $EDITOR to edit your .gpgenv vars',
      Gpgenv::EditCommand

    subcommand 'set',
      'Set a .gpgenv var',
      Gpgenv::SetCommand

    subcommand 'import',
      'Import a .env file to .gpgenv',
      Gpgenv::ImportCommand

    subcommand 'export',
      'export a .gpgenv directory to a .env file',
      Gpgenv::ExportCommand

    def execute
      if version?
        puts Gpgenv.VERSION
      end
    end
  end
end
