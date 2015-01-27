# -*- encoding: utf-8 -*-

require 'spec_helper'
require './lib/bitcasa/item'

describe Bitcasa::Item do

  # TODO: auto-generated
  describe '#new' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      result = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#name=' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      value = double('value')
      result = item.name=(value)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#extension=' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      value = double('value')
      result = item.extension=(value)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#date_created=' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      value = double('value')
      result = item.date_created=(value)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#date_meta_last_modified=' do
    it 'works' do
      client = double('client')
      parent= double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      value = double('value')
      result = item.date_meta_last_modified=(value)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#date_content_last_modified=' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share,params)
      value = double('value')
      result = item.date_content_last_modified=(value)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#mime=' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      value = double('value')
      result = item.mime=(value)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#version=' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      value = double('value')
      result = item.version=(value)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#application_data=' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      hash = double('hash')
      result = item.application_data=(hash)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#exists?' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      result = item.exists?
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#url' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      result = item.url
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#move_to' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      destination = double('destination')
      name = double('name:nil')
      exists = double('exists:RENAME')
      result = item.move_to(destination, name, exists)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#copy_to' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      destination = double('destination')
      name = double('name:nil')
      exists = double('exists:RENAME')
      result = item.copy_to(destination, name, exists)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#delete' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, **params)
      force = double('force:true')
      commit = double('commit:false')
      raise_exception = double('raise_exception:false')
      result = item.delete(force, commit, raise_exception)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#get_properties_from_server' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      result = item.get_properties_from_server
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#restore' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      destination = double('destination:nil')
      exists = double('exists:FAIL')
      raise_exception = double('raise_exception:false')
      result = item.restore(destination, exists, raise_exception)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#versions' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      result = item.versions
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#save' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      version_conflict = double('version_conflict:FAIL')
      result = item.save(version_conflict:'FAIL')
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#get_properties_in_hash' do
    it 'works' do
      client = double('client')
      parent = double('parent:nil')
      in_trash = double('in_trash:false')
      in_share = double('in_share:false')
      params = double('**params')
      item = Bitcasa::Item.new(client, parent, in_trash, in_share, params)
      result = item.get_properties_in_hash
      expect(result).not_to be_nil
    end
  end

end
