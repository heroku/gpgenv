require 'spec_helper'
require 'gpgenv'

describe Gpgenv do
  describe '#read_files' do


    shared_context 'works' do
      it 'works' do
        expect(subject.read_files(dirs)).to eq({
          'file1' => 'value1',
          'file2' => 'value2'
        })
      end
    end 

    let (:subject) { Gpgenv }
    let (:dir) { '/some/dir' } 
    let (:dirs) { [dir] }
    let (:glob) { ['file1', 'file2.gpg', 'subdir']  }
    let (:decrypt_succeeded) { true }
    let (:dir_exists) { true }
    let (:dir_is_a_directory) { true }
    let (:gpgenv_home) { nil }

    before do
      allow(subject).to receive(:`).with('gpg --batch --quiet --decrypt file2.gpg') { 'value2' }
      allow($?).to receive(:success?) { decrypt_succeeded }
    end

    include_context 'works'

    context 'when file decryption fails' do
      let (:decrypt_succeeded) { false }

      it 'fails' do
        expect{ subject.read_files(dirs) }.to raise_error "Decrypting file2.gpg failed."
      end
    end

    context 'when an input directory does not exist' do
      let (:dir_exists) { false }

      it 'fails' do
        expect{ subject.read_files(dirs) }.to raise_error "/some/dir does not exist."
      end
    end

    context 'when an input directory is not actually a directory' do
      let (:dir_is_a_directory) { false }

      it 'fails' do
        expect{ subject.read_files(dirs) }.to raise_error "/some/dir is not a directory."
      end
    end

    context 'when gpgenv_home is set' do
      let (:gpgenv_home) { 'gpgenv_home_dir' }
      let (:gpgenv_prefixed_dir) { "#{gpgenv_home}/#{dir}" }
      let (:gpgenv_prefixed_dir_exists) { true }
      let (:gpgenv_prefixed_dir_is_a_directory) { true }

      before do
        allow(File).to receive(:directory?).with(gpgenv_prefixed_dir) { gpgenv_prefixed_dir_is_a_directory }
        allow(File).to receive(:exists?).with(gpgenv_prefixed_dir) { true }
        allow(Dir).to receive(:glob).with("#{gpgenv_prefixed_dir}/*") { glob }
      end

      context 'when the specified directory is a directory' do
        let (:dir_is_a_directory) { true }
        include_context 'works'
      end

      context 'when the specified directory is not, and we fallback to a gpgenv directory' do
        let (:dir_is_a_directory) { false }
        include_context 'works'
      end

      context 'when neither the original dir nor the gpgenv dir are directories' do
        let (:dir_is_a_directory) { false }
        let (:gpgenv_prefixed_dir_is_a_directory) { false }

        it 'fails' do
          expect{ subject.read_files(dirs) }.to raise_error "/some/dir is not a directory."
        end
      end
    end

  end
end

