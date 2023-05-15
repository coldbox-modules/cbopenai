<cfscript>
    openAIService = getInstance( "OpenAIService@cbopenai" );
    result = openAIService.getModels();
    writeDump( result );
</cfscript>