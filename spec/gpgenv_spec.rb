require 'spec_helper'
require 'gpgenv'

describe Gpgenv do

  describe '#read_files' do

    shared_context 'works' do
      it 'works' do
        expect(subject.read_files).to eq({
          'file1' => 'value1',
        })
      end
    end 

    subject { Gpgenv.new(dir: dir) }
    let (:dir) { '/some/dir' } 
    let (:glob) { ['file1.gpg']  }
    let (:decrypt_succeeded) { true }
    let (:dir_exists) { true }
    let (:dir_is_a_directory) { true }
    let (:gpgenv_home) { nil }

    before do
      allow(subject).to receive(:`).with('gpg --batch --quiet --decrypt file1.gpg') { 'value1' }
      allow($?).to receive(:success?) { decrypt_succeeded }
      allow(Dir).to receive(:glob).with("#{dir}/*.gpg") { glob }
      allow(File).to receive(:read).with("#{dir}/file1.gpg") { 'value1' }
      allow(File).to receive(:exist?).with(dir) { dir_exists }
      allow(File).to receive(:directory?).with(dir) { dir_is_a_directory }
    end

    include_context 'works'

    context 'when file decryption fails' do
      let (:decrypt_succeeded) { false }

      it 'fails' do
        expect{ subject.read_files }.to raise_error "Decrypting file1.gpg failed."
      end
    end

    context 'when an input directory does not exist' do
      let (:dir_exists) { false }

      it 'fails' do
        expect{ subject.read_files }.to raise_error "/some/dir does not exist."
      end
    end

    context 'when an input directory is not actually a directory' do
      let (:dir_is_a_directory) { false }

      it 'fails' do
        expect{ subject.read_files }.to raise_error "/some/dir is not a directory."
      end
    end

  end
end

