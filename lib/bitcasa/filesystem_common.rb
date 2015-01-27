require_relative 'client'

module Bitcasa
	# Provides common filesystem operations consumed by other classes
	module FileSystemCommon
		extend self
		# Create item from hash
		# @param client [Client] restful client instance
		# @option parent [Item|String] parent item of type folder
		# @option in_trash [Boolean] set true to specify, item exists in trash
		# @option in_share [Boolean] set true to specify, item exists in share
		# @option keywords or hash containing key/value pairs of item properties
		# @return [File|Folder|Share] item
		# @raise Client::Errors::ServiceError
		def create_item_from_hash(client, parent: nil, 
				in_trash: false, in_share: false, **hash)
			require_relative 'file'
			require_relative 'folder'
			require_relative 'share'

			if hash.key?(:share_key)
				return Share.new(client, **hash)
			end
			unless hash.key?(:type)
				raise Client::Errors::ArgumentError, "Did not recognize item"
			end
			
			hash[:type] = "folder" if hash[:type] == "root"
			if (hash[:type] == "folder")
				return Folder.new(client, parent: parent, 
						in_trash: in_trash, in_share: in_share, **hash)
			else 
				return File.new(client, parent: parent, 
						in_trash: in_trash, in_share: in_share, **hash)
			end
		end
		
		# Create array items from corresponding array of hashes
		# @param hashes [Hash []] array of hashes containing key/value properties of items
		# @param client [Client] restful client instance
		# @option parent [Item|String] parent item of type folder
		# @option in_trash [Boolean] set true to specify, items exist in trash
		# @option in_share [Boolean] set true to specify, items exist in share
		# @return [File|Folder|Share][] items
		# @raise Client::Errors::ServiceError
		def create_items_from_hash_array(hashes, client, 
				parent: nil, in_trash: false, in_share: false)
			items = []
			hashes.each do |item|
				resp = create_item_from_hash(client, parent: parent, 
						in_trash: in_trash, in_share: in_share, **item)
				items << resp
			end
			items
		end
		
		# Get folder url
		# @param folder [Item|String]
		# @return [String] url of item
		# @raise Client::Errors::ArgumentError
		def get_folder_url(folder)
			return nil if Client::Utils.is_blank?(folder)
			return folder.url if (folder.respond_to?(:url) && 
					folder.respond_to?(:type) && (folder.type == "folder"))
			return folder if folder.is_a?(String)
			raise Client::Errors::ArgumentError, 
				"Invalid input of type #{folder.class}, expected destination item of type folder or string"
		end

		# Get item url
		# @param folder [File|Folder|String]
		# @return [String] url of item
		# @raise Client::Errors::ArgumentError
		def get_item_url(item)
			return nil if Client::Utils.is_blank?(item)
			return item.url if item.respond_to?(:url)
			return item if item.is_a?(String)
			raise Client::Errors::ArgumentError, 
				"Invalid input, expected destination item of type file, folder or string"
		end

		# Get item name
		# @param folder [File|Folder|String]
		# @return [String] name of item
		# @raise Client::Errors::ArgumentError
		def get_item_name(item)
			return nil if Client::Utils.is_blank?(item)
			return item.name if item.respond_to?(:name)
			return item if item.is_a?(String)
			raise Client::Errors::ArgumentError, 
				"Invalid input, expected destination item of type file, folder or string"
		end

		# Validate item's current state for operations
		# @param item [Item] item to validate
		# @option in_trash [Boolean] set false to avoid check if item in trash
		# @option in_share [Boolean] set false to avoid check if item in share
		# @option exists [Boolean] set false to avoid check if item exists
		# @raise Client::Errors::InvalidItemError, Client::Errors::OperationNotAllowedError
		def validate_item_state(item, in_trash: true, in_share: true, exists: true)
			require_relative 'item'
			return nil unless item.kind_of?(Item)
			raise Client::Errors::InvalidItemError, 
				"Operation not allowed as item does not exist anymore" if (exists && item.exists == false)
			raise Client::Errors::OperationNotAllowedError, 
				"Operation not allowed as item is in trash" if (in_trash && item.in_trash)
			raise Client::Errors::OperationNotAllowedError, 
				"Operation not allowed as item is in share" if (in_share && item.in_share)
		end
	
		# Fetches properties of named path by recursively listing each member 
		#			starting root with depth 1 and filter=name=path_member
		# @param client [Client] restful client instance
		# @option named_path [String] named (not pathid) cloudfs path of item i.e. /a/b/c
		# @return [Hash] containing url and meta of item
		# @raise Client::Errors::ServiceError
		def get_properties_of_named_path(client, named_path)
			raise Client::Errors::ArgumentError, 
				"Invalid input, expected destination string" if Client::Utils.is_blank?(named_path)
 			raise Client::Errors::ArgumentError, 
				"invalid client, input type must be Client" unless client.is_a?(Client)

			named_path.insert(0, '/') unless (named_path[0] == '/')
			first, *path_members = named_path.split('/')
			path = first

			response = []
			path_members.each	do |member|
				response = client.list_folder(path: path, depth: 1, 
						filter: "name=#{member}")
				path << "/#{response[0][:id]}" #unless member == path_members.last
			end

			{url: path, meta: response[0]}
		end
	end
end	
