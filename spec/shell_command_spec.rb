require 'spec_helper'
require 'gpgenv/shell_command'

class Gpgenv
  describe ShellCommand do
    let (:subject) { ShellCommand.new(%w'dir1') }
    let (:gpgenv) { double('gpgenv') }

    it 'works' do
      allow(subject).to receive(:gpgenv) { gpgenv }
      allow(gpgenv).to receive(:read_files) { {'key'=>'value'} }
      expect(STDOUT).to receive(:puts).with "export key=value"
      subject.run(%w'-d dir1')
    end

  end
end
