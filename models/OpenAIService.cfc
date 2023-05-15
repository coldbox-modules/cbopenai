component accessors="true" singleton {

	/**
	 * The OpenAI module settings
	 */
	property name="settings" inject="coldbox:modulesettings:cbopenai";

	/**
	 * List and describe the various models available in the API. You can refer to the Models documentation to understand what models are available and the differences between them.
	 *
	 * @return struct
	 */
	function getModels(){
		return sendRequest( endpoint = "https://api.openai.com/v1/models", HTTPMethod = "GET" );
	}

	/**
	 * Retrieves a model instance, providing basic information about the model such as the owner and permissioning.
	 *
	 * @model
	 *
	 * @return struct
	 */
	function getModel( required string model ){
		return sendRequest( endpoint = "https://api.openai.com/v1/models/#arguments.model#", HTTPMethod = "GET" );
	}

	/**
	 * Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.
	 *
	 * @model            string | ID of the model to use
	 * @prompt           string or array | The prompt(s) to generate completions for.
	 * @suffix           string | The suffix that comes after a completion of inserted text.
	 * @maxTokens        numeric | The maximum number of tokens to generate in the completion.
	 * @temperature      numeric | What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
	 * @topP             numeric | An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
	 * @n                numeric | How many completions to generate for each prompt.
	 * @stream           boolean | Whether to stream back partial progress. If set, tokens will be sent as data-only server-sent events as they become available, with the stream terminated by a data: [DONE] message.
	 * @logProps         numeric | Include the log probabilities on the logprobs most likely tokens, as well the chosen tokens.
	 * @echo             boolean | Echo back the prompt in addition to the completion.
	 * @stop             string or array | Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
	 * @presencePenalty  numeric | Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
	 * @frequencyPenalty numeric | Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
	 * @bestOf           numeric | Generates best_of completions server-side and returns the "best" (the one with the highest log probability per token). Results cannot be streamed. When used with n, best_of controls the number of candidate completions and n specifies how many to return – best_of must be greater than n.
	 * @logit_bias       struct | Modify the likelihood of specified tokens appearing in the completion. See OpenAI documentation.
	 * @user             string | A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	 *
	 * @return struct
	 */
	function createCompletion(
		required any prompt,
		string model = "text-davinci-003",
		string suffix,
		numeric max_tokens,
		numeric temperature,
		numeric top_p,
		numeric n,
		boolean stream,
		numeric logprops,
		boolean echo,
		any stop,
		numeric presence_penalty,
		numeric frequency_penalty,
		numeric bestOf,
		struct logit_bias,
		string user
	){
		if ( !isArray( arguments.prompt ) ) {
			arguments.prompt = [ arguments.prompt ];
		}

		var payload = filterArguments( arguments );

		return sendRequest( endpoint = "https://api.openai.com/v1/completions", payload = payload );
	}

	/**
	 * Given a list of messages describing a conversation, the model will return a response.
	 *
	 * @model            string | ID of the model to use
	 * @messages         array | The prompt(s) to generate completions for.
	 * @maxTokens        numeric | The maximum number of tokens to generate in the completion.
	 * @temperature      numeric | What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
	 * @topP             numeric | An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
	 * @n                numeric | How many completions to generate for each prompt.
	 * @stream           boolean | Whether to stream back partial progress. If set, tokens will be sent as data-only server-sent events as they become available, with the stream terminated by a data: [DONE] message.
	 * @logProps         numeric | Include the log probabilities on the logprobs most likely tokens, as well the chosen tokens.
	 * @stop             string or array | Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
	 * @presencePenalty  numeric | Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
	 * @frequencyPenalty numeric | Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
	 * @logit_bias       struct | Modify the likelihood of specified tokens appearing in the completion. See OpenAI documentation.
	 * @user             string | A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	 *
	 * @return struct
	 */
	function createChatCompletion(
		required array messages,
		string model = "gpt-3.5-turbo",
		numeric max_tokens,
		numeric temperature,
		numeric top_p,
		numeric n,
		boolean stream,
		numeric logprops,
		any stop,
		numeric presence_penalty,
		numeric frequency_penalty,
		struct logit_bias,
		string user
	){
		var payload = filterArguments( arguments );

		return sendRequest( endpoint = "https://api.openai.com/v1/chat/completions", payload = payload );
	}

	/**
	 * Creates a new edit for the provided input, instruction, and parameters.
	 *
	 */
	function createEdit(
		required string model = "text-davinci-edit-001",
		string input,
		string instruction,
		numeric n,
		numeric temperature,
		numeric top_p
	){
		var payload = filterArguments( arguments );

		return sendRequest( endpoint = "https://api.openai.com/v1/edits", payload = payload );
	}

	function createImageEdit(
		required string image,
		string mask,
		string prompt,
		numeric n,
		string size,
		string response_format,
		string user
	){
		var payload    = filterArguments( arguments );
		var fileParams = [ "image", "mask" ];

		return sendRequest(
			endpoint    = "https://api.openai.com/v1/images/edits",
			contentType = "multipart/form-data",
			payload     = payload,
			fileParams  = fileParams
		);
	}

	function createImageVariation(
		required string image,
		numeric n,
		string size,
		string response_format,
		string user
	){
		var payload    = filterArguments( arguments );
		var fileParams = [ "image" ];

		return sendRequest(
			endpoint    = "https://api.openai.com/v1/images/variations",
			contentType = "multipart/form-data",
			payload     = payload,
			fileParams  = fileParams
		);
	}


	/**
	 * Returns a generated image for provided prompt and parameters.
	 *
	 * @prompt          string | The prompt to generate an image for.
	 * @n               numeric | How many completions to generate for each prompt.
	 * @size            string | The size of the generate images. Must be one of 256x256, 512x512, or 1024x1024.
	 * @response_format string | The format in which the generated images are returned. Must be one of url or b64_json.
	 * @user            string | A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	 *
	 * @return struct
	 */
	function createImage(
		required string prompt,
		numeric n,
		string size,
		string response_format,
		string user
	){
		var payload = filterArguments( arguments );

		return sendRequest( endpoint = "https://api.openai.com/v1/images/generations", payload = payload );
	}

	/**
	 * Returns structured data of moderation analysis.
	 *
	 * @input string
	 *
	 * @return struct
	 */
	function createModeration( required string input ){
		var payload = filterArguments( arguments );

		return sendRequest( endpoint = "https://api.openai.com/v1/moderations", payload = payload );
	}

	function createEmbedding(
		required any input,
		model = "text-embedding-ada-002",
		string user
	){
		var payload = filterArguments( arguments );

		return sendRequest( endpoint = "https://api.openai.com/v1/embeddings", payload = payload );
	}

	function createAudioTranscription(
		required string file,
		required string model = "whisper-1",
		string prompt,
		string response_format,
		numeric temperature,
		string language
	){
		var payload    = filterArguments( arguments );
		var fileParams = [ "file" ];

		return sendRequest(
			endpoint    = "https://api.openai.com/v1/audio/transcriptions",
			contentType = "multipart/form-data",
			payload     = payload,
			fileParams  = fileParams
		);
	}

	function createAudioTranslation(
		required string file,
		required string model = "whisper-1",
		string prompt,
		string response_format,
		numeric temperature
	){
		var payload    = filterArguments( arguments );
		var fileParams = [ "file" ];

		return sendRequest(
			endpoint    = "https://api.openai.com/v1/audio/translations",
			contentType = "multipart/form-data",
			payload     = payload,
			fileParams  = fileParams
		);
	}

	/**
	 * Sends a HTTP request to OpenAI and returns the response.
	 *
	 * @endpoint    string
	 * @HTTPMethod  string
	 * @contentType string
	 * @payload     struct
	 *
	 * @return struct
	 */
	private function sendRequest(
		required string endpoint,
		string HTTPMethod  = "POST",
		string contentType = "application/json",
		struct payload     = {},
		array fileParams   = []
	){
		if ( variables.settings.keyExists( "apiKey" ) && variables.settings.apiKey.len() ) {
			var response = performHTTPRequest(
				endpoint    = arguments.endpoint,
				HTTPMethod  = arguments.HTTPMethod,
				contentType = arguments.contentType,
				payload     = arguments.payload,
				fileParams  = arguments.fileParams
			);

			if ( response.status_code == "200" && isJSON( response.fileContent ) ) {
				return deserializeJSON( response.fileContent );
			}

			throw( type = "BadRequest", message = response.fileContent );
		}

		throw(
			type    = "MissingModuleSetting",
			message = "You must specify an 'cbopenai.apiKey' in your ColdBox.cfc module settings."
		);
	}


	/**
	 * Actually performs the HTTP request. Good for mocking in tests also.
	 *
	 * @return struct
	 */
	private function performHTTPRequest(
		required string endpoint,
		string HTTPMethod  = "POST",
		string contentType = "application/json",
		struct payload     = {},
		array fileParams   = []
	){
		var response = "";
		cfhttp(
			url    = "#arguments.endpoint#",
			method = "#arguments.HTTPMethod#",
			result = "response"
		) {
			if ( arguments.contentType != "multipart/form-data" ) {
				cfhttpparam(
					type  = "header",
					name  = "Content-Type",
					value = "#arguments.contentType#"
				);
			}
			cfhttpparam(
				type  = "header",
				name  = "Authorization",
				value = "Bearer #variables.settings.apiKey#"
			);
			if ( arguments.HTTPMethod == "POST" && arguments.contentType == "application/json" ) {
				cfhttpparam( type = "body", value = "#serializeJSON( arguments.payload )#" );
			} else {
				payload.each( function( key, value ){
					if ( arrayFindNoCase( fileParams, key ) ) {
						cfhttpparam( type = "file", name = key, file = value );
					} else {
						cfhttpparam( type = "formField", name = key, value = value );
					}
				} );
			}
		}

		return response;
	}

	/**
	 * Filter only the arguments that have values to send in the HTTP payload.
	 *
	 * @return struct
	 */
	private function filterArguments( required struct args ){
		return args.filter( function( key, value, data ){
			return !isNull( data[ key ] ) &&
			(
				( isSimpleValue( value ) && value != "" ) ||
				( isArray( value ) || value.len() ) ||
				( isStruct( value ) || structKeyCount( value ) )
			);
		} );
	}

}
