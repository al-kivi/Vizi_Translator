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
      new_text = ''
      new_text = input_text
      new_text.gsub!("(","<(")
      new_text.gsub!(")",")>")
      new_array = new_text.split(/[<>]/)
      chash = Hash.new
      for i in 0..new_array.length-1
        if new_array[i][0..0] == "("
          old_value = new_array[i]
          new_array[i] = "!"+i.to_s+"!"
          chash[new_array[i]] = old_value
        end
      end
      input_text = new_array.join
      # added new logic to split the file
      if input_text.length > 500 and not input_text.index("$-")
        for i in 0..input_text.length/500-1
          x = input_text[0..500*(i+1)].rindex(/\n/)
          input_text.insert(x+1, '$-')
        end
      end 
      input_text = URI.escape(input_text)
      input_array = Array.new
      if input_text.index("$-")
        input_array = input_text.split("$-")
      else
        input_array[0] = input_text
      end
      # end of splitter logic
      result_all = ""
      for i in 0..input_array.length-1
        begin
          sleep 3 if i > 0
          raise UnSupportedLanguage unless SUPPORTED_LANG_CODES.include?(output_code)
          site_url = 'www.syslang.com'
          uri_method = '/frengly/controller?'
          uri_string = 'action='+default_action+'&src='+default_src+'&dest='+output_code+'&text='+input_array[i]+'&username='+username+'&password='+password
          response = Net::HTTP.get_response(site_url, uri_method + uri_string)
          if response.code == "200"
            xml_data = response.body
            data = XmlSimple.xml_in(xml_data)
            result = data["translation"][0]
            chash.each {|key, value| result.gsub!(key, value) }
            result_all << result
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
      result_all
    end

  end # Class 
  
end # Vizi module
 

