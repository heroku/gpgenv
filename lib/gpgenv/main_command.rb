require 'clamp'
require 'gpgenv/exec_command'
require 'gpgenv/import_command'
require 'gpgenv/export_command'
require 'gpgenv/shell_command'

module Gpgenv
  class MainCommand < Clamp::Command
    subcommand 'exec', 'Exec a command', Gpgenv::ExecCommand
    subcommand 'import', 'Import from .env to gpgenv', ImportCommand
    subcommand 'export', 'Export from gpgenv to .env', ExportCommand
    subcommand 'shell', 'Print out "export" commands, for use with eval', ShellCommand

    def execute
      super
    end
  end
end
