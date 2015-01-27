# -*- encoding: utf-8 -*-

require 'spec_helper'
require './lib/bitcasa/share'

describe Bitcasa::Share do

  # TODO: auto-generated
  describe '#new' do
    it 'works' do
      client = double('client')
      params = double('**params')
      result = Bitcasa::Share.new(client, params)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#changed_properties_reset' do
    it 'works' do
      client = double('client')
      params = double('**params')
      share = Bitcasa::Share.new(client, params)
      result = share.changed_properties_reset
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#name=' do
    it 'works' do
      client = double('client')
      params = double('**params')
      share = Bitcasa::Share.new(client, params)
      value = double('value')
      result = share.name=(value)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#list' do
    it 'works' do
      client = double('client')
      params = double('**params')
      share = Bitcasa::Share.new(client, params)
      result = share.list
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#delete' do
    it 'works' do
      client = double('client')
      params = double('**params')
      share = Bitcasa::Share.new(client, params)
      result = share.delete
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#set_password' do
    it 'works' do
      client = double('client')
      params = double('**params')
      share = Bitcasa::Share.new(client, params)
      password = double('password')
      current_password = double('current_password')
      result = share.set_password(password, current_password)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#save' do
    it 'works' do
      client = double('client')
      params = double('**params')
      share = Bitcasa::Share.new(client, **params)
      password = double('password:nil')
      result = share.save(password)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#receive' do
    it 'works' do
      client = double('client')
      params = double('**params')
      share = Bitcasa::Share.new(client, **params)
      path = double('path:nil')
      exists = double('exists:RENAME')
      result = share.receive(path, exists)
      expect(result).not_to be_nil
    end
  end

end
