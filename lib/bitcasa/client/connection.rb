require 'httpclient'
require_relative 'utils'
require_relative 'error'

module Bitcasa
	class Client
		# Connection is MT safe restful class, it is wrapper on ruby gem httpclient.
		# It maintains a persistent instance of HTTPClient
		# HTTPClient gem:
		#	Features:
		#		Asynchronous http request 
		#		MT safe, Multipart Post, Streaming Post(File/IO), download response streaming
		#		Presistent connection pool: maintains pool of persistent connections that improves peformance drastically by avoiding tcp handshake for subsequent http connections
		#		Normal restful functionality is fully supported
		#		Written in pure ruby
		# see http://www.rubydoc.info/gems/httpclient/frames for documentation on HTTPClient
		# Usage:
		#		conn = Connection.new
		# 	    response = conn.request('GET', "http://www.google.com", :follow_redirect => true)
		class Connection

      # All required HTTP methods
			HTTP_METHODS = {
				GET: 'get',
				POST: 'post',
			 	DELETE: 'delete',
				PUT: 'put'
			}
			attr_reader	:persistent_conn
		
      # Initialize persistent connection with HTTPClient
			def initialize
				@persistent_conn = HTTPClient.new
				@persistent_conn.cookie_manager = nil
					# Setting send and receive timeout to handle execution expired error while uploading, downloading large file. If file is large enough to cross following timeout values it will generate timeout or execution expired exception.
					persistent_conn.connect_timeout = 60
					persistent_conn.send_timeout = 0
				  persistent_conn.receive_timeout = 0
			end
			
			# Request is general method to send http restful requests
			# @param method [String] http verb ['POST'|'GET'|'DELETE'|'PUT'], default "POST"
			# @param uri [String] complete url for http request
			# @option header [Hash] key:value pairs representing http request headers
			# @option query [Hash] query key:value parameters fo request ie. url?key=value&key1=value1
			# @option body [Hash] key:value forms or a String body to post
			# @return response [Hash] {content: nil, content_type: application/json, code: 200}
			# @raise Bitcasa::Client::ClientError, Bitcasa::Client::ServerError
			# 		ClientError wraps httpclient exceptions i.e. timeout, connection failed etc.
			#			ServerError contains message and code from server
			# OPTIMIZE: add request, response context to exceptions, async request support
			# REVIEW: Behaviour in case of error with follow_redirect set to true and callback block for get_content, observed is that if server return message as response body in case of error, message is discarded and unable to fetch it. Opened issue#234 on nahi/httpclient github
			def request(params, &block)
				req_params = {
						method: 'POST',
						uri: '',
						header: {},
						query: {}, 
						body: {}
					}.merge(params)
		
				req_params.delete_if{ |k,v| Utils.is_blank?(v) }
				uri = req_params.delete(:uri)
				raise InvalidArgumentError, "must pass url" if Utils.is_blank?(uri)	
				method = req_params.delete(:method)
				method = HTTP_METHODS[method.to_sym] or raise NoMethodError, 
					"pass correct method i.e. get, post, delete"
				
				req_params[:follow_redirect]	= true if method == "get"
#				puts req_params
#				puts uri
				resp = @persistent_conn.send(method, uri, req_params, &block)
#	puts resp.content
#				puts resp.reason

=begin
				if (resp.respond_to?(:previous) && resp.previous)
						message = resp.previous
						puts "content #{message.content}"
						puts "reason #{message.reason}"
				end
=end
				status = resp.status.to_i
				if status < 200 || status >=400 || resp.redirect?
					message = Utils.is_blank?(resp.content) ? resp.reason : resp.content
					raise Errors::ServerError.new(message, status)
				end
				
				response = {}
				response[:content] = resp.content unless block_given?
				response[:content_type] = resp.header['Content-Type'].first
				response[:code] = resp.code
				response
	
				rescue HTTPClient::TimeoutError
					raise Errors::TimeoutError, $!, $!.backtrace
				rescue HTTPClient::BadResponseError
					raise Errors::ClientError, $!, $!.backtrace
				rescue Errno::ECONNREFUSED, EOFError, SocketError
					raise Errors::ConnectionFailed, $!, $!.backtrace
			end
		end
	end
end
