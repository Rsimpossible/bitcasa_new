require_relative 'item'
require_relative 'client'
require_relative 'filesystem_common'

module Bitcasa
	# File class is aimed to provide native File object like interface to bitcasa cloudfs files
	class File < Item
		attr_reader :offset

		def initialize(client, parent: nil, in_trash: false, in_share: false, **params)
			@offset = 0
			super
		end
	
		# Downlaod this file to local directory
		# @param local_path [String] path of local directory
		# @option filename [String] name of downloaded file, default is name of this file
		# @raise Client::Errors::ServiceError, Client::Errors::ArgumentError
		# OPTIMIZE: Provide options to overwrite, append, fail if file exists at local_path
		def download(local_path, filename: nil)
			raise Client::Errors::ArgumentError, 
				"local path is not a valid directory" unless ::File.directory?(local_path)
			FileSystemCommon.validate_item_state(self)

			filename ||= @name

			if local_path[(local_path.length) - 1] == '/'
				local_filepath = "#{local_path}#{filename}"
			else
				local_filepath = "#{local_path}/#{filename}"
			end
			
			file ||= ::File.open(local_filepath, 'wb')
			
			@client.download(url) do |buffer|
				file.write(buffer)
			end

			ensure
				file.close if file
		end
		
		# Read from file
	 	#	@param size [Fixnum] number of bytes to read from current access position, default reads upto end of file
		# @return [StringIO] stream
		# @raise Client::Errors::ServiceError, Client::Errors::ArgumentError
		# OPTIMIZE provide block to get chunked-data 
		def read(size: nil)
			FileSystemCommon.validate_item_state(self)
			input_stream = StringIO.new
			
			size = @size - @offset unless size
			return input_stream if (@offset > @size || @offset == @size || size == 0)
		
			size = @size - @offset if @offset + size > @size
			
			@client.download(url, startbyte: @offset, bytecount: size) do |chunk|
				input_stream.write(chunk)
			end
			
			input_stream.rewind
			@offset += input_stream.size
		 
			input_stream
		end	
		
		#	Reset file's position indicator 
		def rewind
			@offset = 0
		end
		
		# Return current access position in this file
		# @return [Fixnum] current position in file
		def tell
			@offset
		end

		# Seek to a particular byte this file
		# @param offset [Fixnum] offset in this file to seek to
		# @param whence [Fixnum] defaults 0, 
		#		If whence is 0 file offset shall be set to offset bytes
		#		If whence is 1, the file offset shall be set to its current location plus offset
		#		If whence is 2, the file offset shall be set to the size of the file plus offset
		# @return [Fixnum] resulting offset
		# @raise Client::Errors::ArgumentError
		def seek(offset, whence: 0)
			
			case whence
			when 0 
				@offset = offset if whence == 0
			when 1
				@offset +=offset if whence == 1
			when 2
				@offset = @size + offset if whence == 2
			else
				raise Client::Errors::ArgumentError, 
					"Invalid value of whence, should be 0 or IO::SEEK_SET, 1 or IO::SEEK_CUR, 2 or IO::SEEK_END,"
			end
			
			@offset	
		end
	end
end
