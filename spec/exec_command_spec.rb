require 'gpgenv/exec_command'

class Gpgenv
  describe ExecCommand do
    let (:subject) { ExecCommand.new( %w'dir1 command') }

    it 'works' do
      expect(::Gpgenv).to receive(:exec_command).with('dir1 command')
      subject.run(%w'dir1 command')
    end

  end
end
