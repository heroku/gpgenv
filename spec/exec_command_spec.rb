require 'gpgenv/exec_command'

class Gpgenv
  describe ExecCommand do
    let (:subject) { ExecCommand.new( %w'dir1 command') }
    let (:gpgenv) { double('gpgenv') }

    it 'works' do
      allow(subject).to receive(:gpgenv) { gpgenv }
      expect(gpgenv).to receive(:exec_command).with('dir1 command')
      subject.run(%w'dir1 command')
    end

  end
end
