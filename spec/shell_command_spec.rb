require 'gpgenv/shell_command'

class Gpgenv
  describe ShellCommand do
    let (:subject) { ShellCommand.new(%w'dir1') }

    it 'works' do
      allow(::Gpgenv).to receive(:read_files).with(['dir1']){ {'key' => 'value'} }
      expect(STDOUT).to receive(:puts).with "export key=value"
      subject.run(%w'dir1')
    end

  end
end
