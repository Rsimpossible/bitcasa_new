# -*- encoding: utf-8 -*-

require 'spec_helper'
require './lib/bitcasa/folder'

describe Bitcasa::Folder do

  # TODO: auto-generated
  describe '#upload' do
    it 'works' do
      folder = Bitcasa::Folder.new
      filepath = double('filepath')
      name = double('name:nil')
      exists = double('exists:FAIL')
      result = folder.upload(filepath, name, exists)
      expect(result).not_to be_nil
    end
  end

end
