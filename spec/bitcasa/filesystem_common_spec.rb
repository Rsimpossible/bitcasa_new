# -*- encoding: utf-8 -*-

require 'spec_helper'
require './lib/bitcasa/filesystem_common'

describe Bitcasa::FileSystemCommon do

  # TODO: auto-generated
  describe '#create_item_from_hash' do
    it 'works' do
      file_system_common = Bitcasa::FileSystemCommon.new
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      hash = double('**hash')
      result = file_system_common.create_item_from_hash(client, parent, in_trash, in_share, hash)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#create_items_from_hash_array' do
    it 'works' do
      file_system_common = Bitcasa::FileSystemCommon.new
      hashes = double('hashes')
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      result = file_system_common.create_items_from_hash_array(hashes, client, parent, in_trash, in_share)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#get_folder_url' do
    it 'works' do
      file_system_common = Bitcasa::FileSystemCommon.new
      folder = double('folder')
      result = file_system_common.get_folder_url(folder)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#get_item_url' do
    it 'works' do
      file_system_common = Bitcasa::FileSystemCommon.new
      item = double('item')
      result = file_system_common.get_item_url(item)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#get_item_name' do
    it 'works' do
      file_system_common = Bitcasa::FileSystemCommon.new
      item = double('item')
      result = file_system_common.get_item_name(item)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#validate_item_state' do
    it 'works' do
      file_system_common = Bitcasa::FileSystemCommon.new
      item = double('item')
      in_trash = double('in_trash:true')
      in_share = double('in_share:true')
      exists = double('exists:true')
      result = file_system_common.validate_item_state(item, in_trash, in_share, exists)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#get_properties_of_named_path' do
    it 'works' do
      file_system_common = Bitcasa::FileSystemCommon.new
      client = double('client')
      named_path = double('named_path')
      result = file_system_common.get_properties_of_named_path(client, named_path)
      expect(result).not_to be_nil
    end
  end

end
