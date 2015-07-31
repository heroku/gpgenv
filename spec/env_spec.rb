require 'spec_helper'
require 'gpgenv/env'

module Gpgenv
  describe Env do
    describe '#read_files' do
      let (:subject) { Env }
      let (:dir) { '/some/dir' } 
      let (:dirs) { [dir] }
      let (:glob) { ['file1', 'file2.gpg', 'dir']  }
      let (:decrypt_succeeded) { true }

      before do
        allow(Dir).to receive(:glob).with("#{dir}/*") { glob }
        allow(File).to receive(:directory?).with( 'file1') { false }
        allow(File).to receive(:directory?).with( 'file2.gpg') { false }
        allow(File).to receive(:directory?).with( 'dir') { true }
        allow(File).to receive(:read).with('file1'){ 'value1' }
        allow(subject).to receive(:`).with('gpg --batch --quiet --decrypt file2.gpg') { 'value2' }
        allow($?).to receive(:success?) { decrypt_succeeded }
      end

      it 'works' do
        expect(subject.read_files(dirs)).to eq({
          'file1' => 'value1',
          'file2' => 'value2'
        })
      end

      context 'when file decryption fails' do
        let (:decrypt_succeeded) { false }

        it 'fails' do
          expect{ subject.read_files(dirs) }.to raise_error "Decrypting file2.gpg failed."
        end
      end

    end
  end

end
