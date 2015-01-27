require_relative 'item'
require_relative 'client'
require_relative 'filesystem_common'

module Bitcasa
	# Bitcasa Container class 
	class Container < Item
		
		# List contents of this container
		# @return array containing list of items
		# @raise Client::Errors::ServiceError, Client::Errors::ArgumentError
		def list
			raise Client::Errors::InvalidItemError, 
				"Operation not allowed as item does not exist anymore" unless @exists

			if @in_trash
				response = @client.browse_trash(path: url)
				response = response.fetch(:items)
			else
				response = @client.list_folder(path: url, depth: 1)
			end
			FileSystemCommon.create_items_from_hash_array(response, 
					@client, parent: url, in_trash: @in_trash)
		end

		# Create folder under this container
		# @param item [Folder|String] string or item's name will be used
		# @option exists ["FAIL"|"OVERWRITE"|"RENAME"|"REUSE"] action to take if the item already exists, defaults "FAIL"
		# @return Folder instance
		# @raise Client::Errors::ServiceError, Client::Errors::ArgumentError
		# REVIEW: Behaviour in case item param is a Folder object
		def create_folder(item, exists: 'FAIL')
			raise Client::Errors::ArgumentError, 
				"Invalid input, expected items" if Client::Utils.is_blank?(item)
			FileSystemCommon.validate_item_state(self)	
			
			name = FileSystemCommon.get_item_name(item)
			
			response = @client.create_folder(url, name, exists: exists)
			FileSystemCommon.create_item_from_hash(@client, parent: url, **response)
		end
	end
end
