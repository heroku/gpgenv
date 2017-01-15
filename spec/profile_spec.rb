require 'spec_helper'
require 'gpgenv/profile'

describe Gpgenv::Profile do

  subject{ Gpgenv::Profile.new(file, name) }
  let (:file) { 'some-file.gpgenvrc' }
  let (:name) { 'profile-name' }
  let (:file_exists) { true }
  let (:file_contents) { { 'profile-name' => [ '/path/to/somedirectory' ] }.to_yaml }
  let (:gpgenv) { double('gpgenv', read_files: gpgenv_hash) }
  let (:gpgenv_hash) { {'key' => 'value' } }
  let (:cmd) { 'some-command' }

  before do
    allow(File).to receive(:exist?).with(file) { file_exists }
    allow(File).to receive(:read) { file_contents }
    allow(Gpgenv).to receive(:new).with( dir: '/path/to/somedirectory' ) { gpgenv }
    allow(subject).to receive(:exec).with(gpgenv_hash, cmd)
  end

  context 'when .gpgenvrc does not exist' do
    let (:file_exists) { false }
    it 'fails' do
      expect{ subject.exec_command(cmd)}.to raise_error(".gpgenvrc file does not exist")
    end
  end

  context 'when .gpgenvrc does not contain a yaml hash' do
    let(:file_contents) { [].to_yaml }
    it 'fails' do
      expect{subject.exec_command(cmd)}.to raise_error("Invalid .gpgenvrc file")
    end
  end

  context 'when the value in the hash is not an array' do
    let(:file_contents) { {'profile-name' => 'this is not an array'}.to_yaml }
    it 'fails' do
      expect{subject.exec_command(cmd)}.to raise_error("Invalid .gpgenvrc file")
    end
  end

  context 'when the profile does not exist' do
    let(:file_contents) { {}.to_yaml }
    it 'fails' do
      expect{subject.exec_command(cmd)}.to raise_error("No such profile: profile-name in .gpgenvrc")
    end
  end

  context 'when .gpgenvrc contains invalid yaml' do
    let(:file_contents) { "{" }
    it 'fails' do
      expect{subject.exec_command(cmd)}.to raise_error(/Malformed .gpgenvrc file/)
    end
  end

  it 'works' do
    expect(subject).to receive(:exec).with(gpgenv_hash, cmd)
    subject.exec_command(cmd)
  end
end
