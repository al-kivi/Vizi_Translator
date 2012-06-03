# This gem module provides a language translator class based on the Frengly
# language translation service. The language translation is provided through an 
# HTTP service and requires a registered username and password.
#
# Author::    Al Kivi <al.kivi@vizitrax.com>
# License::   MIT

module Vizi
	require 'net/http'
	require 'uri'
	require 'xmlsimple'
	
	class UnSupportedLanguage < RuntimeError
		attr :msg
		def initialize(message='')
			@msg = "Language pair not supported yet."
		end
	end	

# This class includes a set of methods to translate using the Frengly service
	class Translator
		SUPPORTED_LANG_CODES = ['fr','de','es','pt','it','nl','tl','fi','el','iw','pl','ru','sv']
		SUPPORTED_LANG_LIST  = {"English" => "en", "French" => "fr", "German" => "de", "Spanish" => "es", 
			"Portuguese" => "pt", "Italian" => "it", "Filipino" => "tl","Finnish" => "fi","Greek" => "el",
			"Hebrew" => "iw", "Polish" => "pl", "Russian" => "ru", "Swedish" => "sv"}    

		# method to get array of language codes
		def getcodes
			result = SUPPORTED_LANG_CODES
		end

		# method to get hash list of languages
		def getlist
			result = SUPPORTED_LANG_LIST
		end

		# method to translate from one language to another
		def gettext(username, password, input_text, output_code)
			default_src = 'en'
			default_action = 'translateREST'
		
			input_text = URI.escape(input_text)
			begin
				raise UnSupportedLanguage unless SUPPORTED_LANG_CODES.include?(output_code)			
				site_url = 'www.syslang.com'
				uri_method = '/frengly/controller?'
				uri_string = 'action='+default_action+'&src='+default_src+'&dest='+output_code+'&text='+input_text+'&username='+username+'&password='+password
				response = Net::HTTP.get_response(site_url, uri_method + uri_string)
				if response.code == "200"
					xml_data = response.body
					data = XmlSimple.xml_in(xml_data)
					result = data["translation"][0]						
				else
					puts response.body
					raise StandardError, response.body
				end
			rescue UnSupportedLanguage
				raise UnSupportedLanguage.new
			rescue => err_msg
				puts "#{err_msg}"
			end
		end
		
	end
	
end
 

