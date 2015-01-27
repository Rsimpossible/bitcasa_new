require_relative 'client'
require_relative 'account'
require_relative 'user'
require_relative 'filesystem'

module Bitcasa
	# Establishes a session with the API server on behalf of an authenticated end-user
	class Session

		attr_accessor :clientid, :secret, :host, :admin_credentials
		attr_reader :client

		# Initialize Session instance
		# @param clientid [String] account clientid
		# @param secret [String] account secret
		# @param host [String] api server url
		def initialize(clientid, secret, host)
			@clientid = clientid
			@secret = secret
			@host = host
			@client = Client.new(clientid, secret, host)
			@admin_credentials = {}
		end
	
		# Set admin [PAID	Account] credentials
		# @param params Hash containing credentials
		#		should be {clientid: nil, secret: nil, host: "access.bitcasa.com"} format
		def admin_credentials=(params={})
			@admin_credentials = {clientid: nil, secret: nil, host: "access.bitcasa.com"}.merge(params)
		end
		
		# Get Admin credentials
		# @returns [String] format clientid[clientid] secret[secret] host[host]
		def admin_credentials
			@admin_credentials.map{|k, v| "#{k}['#{v}']"}.join(' ')
		end
		
	# Attempts to log into the end-user's filesystem, linking this session to an account
		# @param username [String] end user's username
		# @param password [String] end user's password
		# @return [Boolean] true if successful, maintains access token in Client instance
		# @raise Client::Errors::ServiceError, Client::Errors::ArgumentError
		def authenticate(username, password)
			@client.authenticate(username, password)
		end

		# Tests to see if the current session is linked to the API server and can make requests	
		# return [Boolean] true/false
		def is_linked
			@client.is_linked
		end

		# Discards current authentication, authenticate again in-order to reuse this session
		def unlink
			@client.unlink
		end

		# Gets object representing the current user
		# @return [Bitcasa::User] object
		def get_user
			response = @client.get_profile
			User.new(@client, **response)
		end

		# Creates a new end-user account for a Paid CloudFS account
		# @param username [String] username of the end-user
		# @param password [String] password of the end-user
		# @option email [String] email of the end-user
		# @option first_name [String] first name of end user
		# @option last_name [String] last name of end user
		# @return [Bitcasa::Account] object
		# @raise Client::Errors::ServiceError, Client::Errors::ArgumentError
		def create_account(username, password, email: nil, 
				first_name: nil, last_name: nil)
			client = Client.new(@admin_credentials[:clientid], 
					@admin_credentials[:secret], @admin_credentials[:host])
				
			response = client.create_account(username, password, email: email, 
				first_name: first_name, last_name: last_name)
			Account.new(@client, **response)
		end
		
		# Gets object representing the current account
		# @return [Bitcasa::Account] object
		def get_account
			response = @client.get_profile
			Account.new(@client, **response)
		end

		# Get filesystem object linked to this session
	 	# @return [Bitcasa::FileSystem] object
		def get_filesystem
			FileSystem.new(@client) 
		end

		# Action history lists history of file, folder, and share actions
		# @option start [Fixnum] version number to start listing historical actions from, default -10. It can be negative in order to get most recent actions.
		# @option stop [Fixnum] version number to stop listing historical actions from (non-inclusive)
		# @return array of hashes containing history items
		# @raise Client::Errors::ServiceError
		def action_history(start: -10, stop: 0)
			@client.list_history
		end

	end
end
