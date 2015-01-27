require "cgi"
require 'base64'
require 'openssl'
require 'multi_json'

module Bitcasa
	class Client
		# Utility functions module, used to handle common tasks
		module Utils 
			extend self
		
			def urlencode(value)
				CGI.escape("#{value}")
			end
	
			# REVIEW does not handle nested hash
			def hash_to_urlencoded_str(hash = {}, delim, join_with)
				hash.map{|k,v| 
					"#{urlencode(k)}#{delim}#{urlencode(v)}"}.join("#{join_with}")
			end
			
			# REVIEW
			def sort_hash(hash={})
				sorted_hash = {}
				hash.sort_by{ |k,v| k.to_s.downcase }.each {|k,v| sorted_hash["#{k}"]= v}
				sorted_hash
			end

			def generate_auth_signature(endpoint, params, headers, secret)
				params_sorted = sort_hash(params)
				params_encoded = hash_to_urlencoded_str(params_sorted, "=", "&")
				headers_encoded = hash_to_urlencoded_str(headers, ":", "&")
				string_to_sign = "POST&#{endpoint}&#{params_encoded}&#{headers_encoded}" 	
				hmac_str = OpenSSL::HMAC.digest('sha1', secret, string_to_sign)
				Base64.strict_encode64("#{hmac_str}")
			end
		
			def json_to_hash(json_str)
				MultiJson.load(json_str, :symbolize_keys=>true)
			end
		
			def hash_to_json(hash={})
				MultiJson.dump(hash)
			end
		
			def hash_to_arguments(hash, *field)
				if field.any? {|f| hash.key?(f)}
					return hash.values_at(*field)
				end
			end	
		
			def is_blank?(var)
				var.respond_to?(:empty?) ? var.empty? : !var
			end
		
		end
	end
end
