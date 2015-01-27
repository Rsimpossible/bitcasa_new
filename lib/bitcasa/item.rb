require_relative 'filesystem_common'
require_relative 'client'

module Bitcasa
	# Class item represents a Bitcasa file, folder
	#	TODO:	URL/PATH validation regex  
	class Item	

		attr_accessor :id, :parent_id, :type, :name, :date_created, 
			:date_meta_last_modified, :date_content_last_modified, :version, 
			:is_mirrored, :mime, :blocklist_key, :extension, :blocklist_id, :size, 
			:application_data, :absolute_path
		
		attr_reader :client, :in_trash, :in_share, :exists, :changed_properties
		
		# @param client restful Client instance
		# @option parent [Item|String] parent item of type folder
		# @option in_trash [Boolean] set true to specify item exists in trash
		# @option keywords or hash containing following key/value pairs
		def initialize(client, parent: nil, in_trash: false, 
				in_share: false, **params)
		raise Client::Errors::ArgumentError, 
				"invalid client, input type must be Bitcasa::Client" unless client.is_a?(Client)
			
			@client = client
			set_item_properties(parent: parent, in_trash: in_trash, 
					in_share: in_share, **params)	
		end
		
		# @option parent [Item|String] parent item of type folder
		# @option in_trash [Boolean] set true to specify item exists in trash
		# @option in_share [Boolean] set true to specify item exists in share
		# @option keywords or hash containing following key/value pairs
		def set_item_properties(parent: nil, in_trash: false, 
				in_share: false, **params)
			@id = params[:id]
			@parent_id = params[:parent_id]
			@type = params[:type]
			@name = params[:name]
			@date_created = params[:date_created]
			@date_meta_last_modified = params[:date_meta_last_modified]
			@date_content_last_modified = params[:date_content_last_modified]
			@version = params[:version]
			@is_mirrored = params[:is_mirrored]
			@mime = params[:mime]
			@blocklist_key = params[:blocklist_key]
			@extension = params[:extension]
			@blocklist_id = params[:blocklist_id]
			@size = params[:size]
			@application_data = params[:application_data]
			@in_trash = in_trash
			@in_share = in_share
			@exists = true
			set_url(parent)
			changed_properties_reset
		end
		
		def changed_properties_reset
			@changed_properties = {application_data: {}}
		end

		def name=(value)
			FileSystemCommon.validate_item_state(self)
			@name = value
			@changed_properties[:name] = value
		end
		
		def extension=(value)
			FileSystemCommon.validate_item_state(self)
			@extension = value
			@changed_properties[:extension] = value
		end
	
		def date_created=(value)
			FileSystemCommon.validate_item_state(self)
			@date_created = value
			@changed_properties[:date_created] = value
		end

		def date_meta_last_modified=(value)
			FileSystemCommon.validate_item_state(self)
			@date_meta_last_modified = value
			@changed_properties[:date_meta_last_modified] = value
		end

		def date_content_last_modified=(value)
			FileSystemCommon.validate_item_state(self)
			@date_content_last_modified = value
			@changed_properties[:date_content_last_modified] = value
		end

		def mime=(value)
			FileSystemCommon.validate_item_state(self)
			@mime = value
			@changed_properties[:mime] = value
		end

		def version=(value)
			FileSystemCommon.validate_item_state(self)
			@version = value
			changed_properties[:version] = value
		end
		# OPTIMIZE: support update of nested hash, currently overwrites nested hash	
		def application_data=(hash={})
			FileSystemCommon.validate_item_state(self)
			if @application_data 
					@application_data = @application_data.merge(hash)
			else
					@application_data = hash
			end
			@changed_properties[:application_data] = @changed_properties[:application_data].merge(hash)
		end

		def exists?
			@exists
		end

		def url
			@absolute_path
		end

		# Move this item to destination folder
		#		Locally changed properties get discarded Unless Item#save has been called.
		# @param destination [Item|String] destination to move item to, should be folder
		# @option name [String] name of moved item
		# @option exists ["FAIL"|"OVERWRITE"|"RENAME"] action to take in case of a conflict with an existing item in destination folder, default "RENAME"
	 	# @return Item instance containing metadata of moved item
		# @raise Client::Errors::ServiceError, Client::Errors::ArgumentError
		def move_to(destination, name: nil, exists: 'RENAME')

			FileSystemCommon.validate_item_state(self)
			FileSystemCommon.validate_item_state(destination)
	
			destination_url = FileSystemCommon.get_folder_url(destination)	
			name = @name unless name
		
			if @type == "folder"
				response = @client.move_folder(url, destination_url, name, exists: exists)
			else
				response = @client.move_file(url, destination_url, name, exists: exists)
			end
				# Overwrite this item's properties with Moved Item's properties
				set_item_properties(parent: destination_url, **response)	
			self
		end
		
		# Copy this item to destination
		#		Locally changed properties are not copied Unless Item#save has been called.
		# @param destination [Item|String] destination to copy item to, should be folder
		# @option name [String] name of copied item
		# @option exists ["FAIL"|"OVERWRITE"|"RENAME"] action to take in case of a conflict with an existing item in destination folder, default "RENAME"
	 	# @return Item instance containing metadata of copied item
		# @raise Client::Errors::ServiceError, Client::Errors::ArgumentError
		def copy_to(destination, name: nil, exists: 'RENAME')
			
			FileSystemCommon.validate_item_state(self)
			FileSystemCommon.validate_item_state(destination)

			destination_url = FileSystemCommon.get_folder_url(destination)	
			name = @name unless name
		
			if @type == "folder"
				response = @client.copy_folder(url, destination_url, 
						name: name, exists: exists)
			else
				response = @client.copy_file(url, destination_url, 
						name: name, exists: exists)
			end
				FileSystemCommon.create_item_from_hash(@client, 
						parent: destination_url, **response)
		end

		# Delete this item
		# @option force [boolean] default false, set true to delete non-empty folder, defailt false
		# @option commit [boolean] default false, set true to remove item permanently, else will be moved to trash, default false 
		# @option raise_exception [Boolean] default false, method suppresses exceptions and returns false if set to false, added so that consuming application can control behaviour
		# @return true/false
		# @raise Client::Errors::ServiceError if raise_exception is true
		def delete(force: true, commit: false, raise_exception: false)
			FileSystemCommon.validate_item_state(self, in_trash: false)

			if @in_trash
				# REVIEW: NOOP if commit is false since item is already in trash, return true
				if commit
					@client.delete_trash_item(path: url)
					@exists = false
					@in_trash = false
				end
				return true
			end

			if @type == "folder"
				@client.delete_folder(url, force: force, commit: commit)
			else
				@client.delete_file(url, commit: commit)
			end
		
			if commit
				@exists = false 
				@in_trash = false
			else
				@application_data[:_bitcasa_original_path] = ::File.dirname(url)
				set_url(nil)
		 		@in_trash = true
			end	
	
			true
			rescue Client::Errors::ServiceError
				raise $! if raise_exception == true
				false
		end
		
		# Get an item's properties from server
		# @param client restful Client instance
		# @param parent_url [String] path of parent
		# @param id [String] pathid of item
		# @param type ["file"||"folder"]
		# @return hash containing metadata of item
		# @raise Client::Errors::ServiceError
		def get_item_properties_from_server(client, parent_url, id, type, in_trash: false)
			item_url = parent_url == "/" ? "/#{id}" : "#{parent_url}/#{id}"
			if in_trash == true
				response = client.browse_trash(path: item_url)
				properties = response.fetch(:meta)
			elsif type == "folder"
				properties = client.get_folder_meta(item_url)
			else
				properties = client.get_file_meta(item_url)
			end
			properties
		end
	
		# Get this item's properties from server
		# @return hash containing metadata of this item
		# @raise Client::Errors::ServiceError
		def get_properties_from_server
			if @in_trash == true
				response = @client.browse_trash(path: url)
				properties = response.fetch(:meta)
			elsif @type == "folder"
				properties = @client.get_folder_meta(url)
			else
				properties = @client.get_file_meta(url)
			end
			properties
		end

		# Sets restored item's url and properties based on exists and destination url
		#		Restored item's url = orginal path if exists is FAIL or if original path's parent exists else url should be destination_url/trash_item's id for exists = RESCUE
		# @param destination_url [String] rescue (default root) or recreate(named path) path depending on exists option to place item into if the original path does not exist
		# @param exists ["FAIL"|"RESCUE"|"RECREATE"] action to take if the recovery operation encounters issues, default 'FAIL'
		# @raise Client::Errors::ServiceError
		def set_restored_item_properties(destination_url, exists)
			begin
				parent_url = @application_data[:_bitcasa_original_path]
				properties = get_item_properties_from_server(@client, parent_url, @id, @type)
			rescue
				raise $! if exists == "FAIL"

				if exists == "RESCUE"
					parent_url = destination_url
					properties = get_item_properties_from_server(@client, parent_url, 
							@id, @type)
				elsif exists == "RECREATE"
			 		response = FileSystemCommon.get_properties_of_named_path(client, 
							destination_url)
					parent_url = response[:url] 
					properties = get_item_properties_from_server(@client, parent_url, 
							@id, @type)
				end
			end
			set_item_properties(parent: parent_url, in_trash: false, **properties)
		end	

		# Restore this item, if in trash
		# @option destination [Folder|String] rescue (default root) or recreate(named path) path depending on exists option to place item into if the original path does not exist
		# @option exists ["FAIL"|"RESCUE"|"RECREATE"] action to take if the recovery operation encounters issues, default 'FAIL'
		# @option raise_exception [Boolean] default false, method suppresses exceptions and returns false if set to false, added so that consuming application can control behaviour
		# @return true/false
		# @raise Client::Errors::ServiceError if raise_exception is true
		def restore(destination: nil, exists: 'FAIL', raise_exception: false)
			raise Client::Errors::OperationNotAllowedError, 
				"Item needs to be in trash for Restore operation" unless @in_trash
			FileSystemCommon.validate_item_state(destination)

			destination_url = FileSystemCommon.get_folder_url(destination)	
			@client.recover_trash_item(url, destination: destination_url, restore: exists)
			
			set_restored_item_properties(destination_url, exists)
			true
			rescue Client::Errors::ServiceError
				raise $! if raise_exception == true
				false
		end

		# List versions of this item if file
		# @return array of items
		# @raise Client::Errors::ServiceError
		def versions
			# REVIEW: Confirm if versions should be allowed for items in trash, in share 
			FileSystemCommon.validate_item_state(self, in_trash: false, in_share: false)
			# REVIEW: Could return self in case of folder as folder has only current version
			raise NoMethodError, 
				"Undefine method versions for item of type #{@type}" unless @type == "file"
				
			response = @client.list_file_versions(url)
			FileSystemCommon.create_items_from_hash_array(response, @client, 
					parent: url, in_share: @in_share, in_trash: @in_trash)
		end

		# Save this item's current state to bitcasa
		# @param version_conflict ["FAIL"|"IGNORE"] action to take if the version on this item does not match the version on the server
		# @raise Client::Errors::ServiceError
		# REVIEW: check if item needs to be updated with returned meta
		def save(version_conflict: 'FAIL')
			FileSystemCommon.validate_item_state(self)
			
			if @type == "folder"
				@client.alter_folder_meta(url, @version, 
						version_conflict: version_conflict, **@changed_properties)
			else
				@client.alter_file_meta(url, @version, 
						version_conflict: version_conflict, **@changed_properties)
			end
			changed_properties_reset 
			nil
		end

		# gets properties in hash format
		def get_properties_in_hash
			properties = {
				:'name' => "#{@name}",
				:'date_created' => "#{@date_created}",
				:'date_meta_last_modified' => "#{@date_meta_last_modified}",
				:'date_content_last_modified' => "#{@date_content_last_modified}",
				:'extension' => "#{@extension}",
				:'mime' => "#{@mime}",
				:'application_data' => @application_data
			}
		end

		# Sets the absolute path of item
		# @param parent [String]  to set item to folder
		# @param item [item|String] is a File
		def set_url(parent)
			parent_url = FileSystemCommon.get_folder_url(parent)
			@absolute_path = parent_url == "/" ? "/#{@id}" : "#{parent_url}/#{@id}"
		end
		
		private :set_url, :set_item_properties, #:get_properties_in_hash, 
			:changed_properties_reset, :set_restored_item_properties, :get_item_properties_from_server
	end
end
