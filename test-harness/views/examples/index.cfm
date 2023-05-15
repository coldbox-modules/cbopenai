<cfscript>

    openAIService = getInstance( "OpenAIService@cbopenai" );

    writeDump( openAIService.createAudioTranscription(
        file = expandPath( "/includes/audio/obi_wan_hello_there.mp3" )
    ) );

    abort;
</cfscript>