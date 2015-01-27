# -*- encoding: utf-8 -*-

require 'spec_helper'
require './lib/bitcasa/file'

describe Bitcasa::File do

  # TODO: auto-generated
  describe '#new' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      result = Bitcasa::File.new(client, parent, in_trash, in_share, params)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#download' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      file = Bitcasa::File.new(client, parent, in_trash, in_share, params)
      local_path = double('local_path')
      filename = double('filename:nil')
      result = file.download(local_path, filename:nil)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#read' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      file = Bitcasa::File.new(client, parent, in_trash, in_share, params)
      size = double('size:nil')
      result = file.read(size:nil)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#rewind' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      file = Bitcasa::File.new(client, parent, in_trash, in_share, params)
      result = file.rewind
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#tell' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      file = Bitcasa::File.new(client, parent, in_trash, in_share, params)
      result = file.tell
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#seek' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      file = Bitcasa::File.new(client, parent, in_trash, in_share,params)
      offset = double('offset')
      whence = double('whence:0')
      result = file.seek(offset, whence:0)
      expect(result).not_to be_nil
    end
  end

end
