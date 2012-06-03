# This is a sample application that uses the Vizi_tracker gem classes
# 
# This application will read a text file for translation.
# The sample text file is a index markdown file written in English;
# The English markdown file provides content for Vizitrax's home page.
# The translated file can be used to replace the English content with content for another language.
#
# Author::    Al Kivi <al.kivi@vizitrax.com>

##	require 'c:\ruby-gems\vizi_translator\lib\vizi_translator'
	require 'rubygems'
	require 'vizi_translator'

	require 'logger'
	syslog = Logger.new('./log/system.log',shift_age = 'weekly')

p 'starting'
  syslog.info "Starting ... >>> "+Time.now.to_s
  
# Set username and password. Username must be registered at Frengly
	username = "akivi"
	password = "welcome123"
	
# Set target language for translation
	targetlanguage = "fr"

	begin
# 	Open test file for translation
		@test = File.read(Dir.pwd+'/data/index.md')
	p 'input file ...'
	p	@test
		syslog.info @test

# 	Initiate Translator class        
		translator = Vizi::Translator.new
#		Get array with available language codes
		@langcodes = translator.getcodes
	p	@langcodes
#		Get hashed list of languages and language codes
		@langlist = translator.getlist
	p	@langlist
    
#		Call method to do the translation
		@testnew = translator.gettext(username, password, @test, targetlanguage)
	p 'output file ...'
	p @testnew
		syslog.info @testnew

	p	'ending'
		syslog.info "Ending ... >>> "+Time.now.to_s
	end

