require 'gpgenv/exec_command'

module Gpgenv
  describe ExecCommand do
    let (:subject) { ExecCommand.new( %w'dir1 command') }

    it 'works' do
      allow(::Gpgenv).to receive(:read_files).with(['dir1']){ {'key' => 'value'} }
      expect(ENV).to receive(:[]=).with('key', 'value')
      expect(subject).to receive(:exec).with('command')
      subject.run 
    end

  end
end
