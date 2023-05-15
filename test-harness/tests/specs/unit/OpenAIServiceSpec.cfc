component extends="coldbox.system.testing.BaseTestCase" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		describe( "OpenAIService.cfc", function(){
			beforeEach( function( currentSpec ){
				setup();
				openAIService = prepareMock( getInstance( "OpenAIService@cbopenai" ) );
				openAIService.setSettings( {
					"apiKey": "fake-key"
				} );
			} );

			it( "can instantiate a component", function(){
				expect( isObject( openAIService ) ).toBeTrue();
			} );

			it( "throw error if an api key is not provided", function() {
				expect( function() {
					openAIService.setSettings( {} );
					openAIService.createModeration( input="test" );
				} ).toThrow( type="MissingModuleSetting" );
			} );

			describe( "models", function() {
				it( "returns the models", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"object": "list",
							"data": [
								"id": "whisper-1",
								"object": "model",
								"owned_by": "openai-internal",
								"permission": []
							]
						} )
					} );
					var result = openAIService.getModels();
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/models" );
					expect( callLog.HTTPMethod ).toBe( "GET" );
					expect( callLog.contentType ).toBe( "application/json" );
					expect( result ).toBeStruct();
				} );
			} );

			describe( "model", function() {
				it( "returns the model", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"id": "text-davinci-003",
							"object": "model"
						} )
					} );
					var result = openAIService.getModel( "text-davinci-003" );
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/models/text-davinci-003" );
					expect( callLog.HTTPMethod ).toBe( "GET" );
					expect( callLog.contentType ).toBe( "application/json" );
					expect( result ).toBeStruct();
					expect( result.id ).toBe( "text-davinci-003" );
				} );
			} );

			describe( "completion", function() {
				it( "returns a completion", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"id": "",
							"object": "text-completion",
							"model": "text-davinci-003",
							"choices": [
								{
									"text": "Yes, this is a test"
								}
							]
						} )
					} );
					var result = openAIService.createCompletion( prompt="Say this is a test." );
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/completions" );
					expect( callLog.HTTPMethod ).toBe( "POST" );
					expect( callLog.contentType ).toBe( "application/json" );
					expect( callLog.payload.prompt ).toBe( [ "Say this is a test." ] );
				} );
			} );

			describe( "chat completion", function() {
				it( "returns a chat completion", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"id": "",
							"object": "text-completion",
							"model": "gpt-3.5-turbo-0301",
							"choices": [
								{
									"message": {
										"role": "assistant",
										"content": "Hi there! How can I assist you today?"
									}
								}
							]
						} )
					} );
					var result = openAIService.createChatCompletion( messages = [
						{
							"role": "user",
							"content": "Hello there!"
						}
					] );
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/chat/completions" );
					expect( callLog.HTTPMethod ).toBe( "POST" );
					expect( callLog.contentType ).toBe( "application/json" );
					expect( callLog.payload.messages[ 1 ].content ).toBe( "Hello there!" );
				} );
			} );

			describe( "images", function() {
				it( "returns a generated image", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"created": "123423423",
							"data": [
								{
									"url": "https://somelongurl"
								}
							]
						} )
					} );
					var result = openAIService.createImage( prompt="Dog with a hat." );
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/images/generations" );
					expect( callLog.HTTPMethod ).toBe( "POST" );
					expect( callLog.contentType ).toBe( "application/json" );
					expect( callLog.payload.prompt ).toBe( "Dog with a hat." );
				} );
			} );

			describe( "image edits", function() {
				it( "returns a generated image edit", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"created": "123423423",
							"data": [
								{
									"url": "https://somelongurl"
								}
							]
						} )
					} );
					var result = openAIService.createImageEdit( image=expandPath( "somefile.png" ) );
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/images/edits" );
					expect( callLog.HTTPMethod ).toBe( "POST" );
					expect( callLog.contentType ).toBe( "multipart/form-data" );
					expect( callLog.payload.image ).toInclude( "somefile.png" );
				} );
			} );

			describe( "image variations", function() {
				it( "returns a generated image variations", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"created": "123423423",
							"data": [
								{
									"url": "https://somelongurl"
								}
							]
						} )
					} );
					var result = openAIService.createImageVariation( image=expandPath( "somefile.png" ) );
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/images/variations" );
					expect( callLog.HTTPMethod ).toBe( "POST" );
					expect( callLog.contentType ).toBe( "multipart/form-data" );
					expect( callLog.payload.image ).toInclude( "somefile.png" );
				} );
			} );


			describe( "edits", function() {
				it( "returns an edit", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"object": "edit",
							"choices": [
								{
									"text": "What day of the week is it?"
								}
							]
						} )
					} );
					var result = openAIService.createEdit(
						input="What day of the week si it?",
						instruction="Fix the spelling mistakes"
					);
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/edits" );
					expect( callLog.HTTPMethod ).toBe( "POST" );
					expect( callLog.contentType ).toBe( "application/json" );
					expect( callLog.payload.input ).toBe( "What day of the week si it?" );
				} );
			} );

			describe( "embeddings", function() {
				it( "returns an embedding", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"object": "edit",
							"data": [
								{
									"object": "embedding",
									"embedding": [
										0.0023434,
										0.234934234
									]
								}
							]
						} )
					} );
					var result = openAIService.createEmbedding(
						input="The food was delicious and the waiter..."
					);
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/embeddings" );
					expect( callLog.HTTPMethod ).toBe( "POST" );
					expect( callLog.contentType ).toBe( "application/json" );
					expect( callLog.payload.input ).toBe( "The food was delicious and the waiter..." );
				} );
			} );


			describe( "moderation", function() {
				it( "moderation with basic input calls API", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": "{}"
					} );
					var result = openAIService.createModeration( input="The cat and the hat." );
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/moderations" );
					expect( callLog.HTTPMethod ).toBe( "POST" );
					expect( callLog.contentType ).toBe( "application/json" );
					expect( callLog.payload.input ).toBe( "The cat and the hat." );
				} );

				it( "a non-200 status code throws error", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 400,
						"fileContent": "{}"
					} );
					expect( function() {
						var result = openAIService.createModeration( input="The cat and the hat." );
					} ).toThrow( "BadRequest" );
				} );
			} );

			describe( "audio transcription", function() {
				it( "returns a generated transactions", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"text": "Hello there"
						} )
					} );
					var result = openAIService.createAudioTranscription( file=expandPath( "somefile.mp3" ) );
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/audio/transcriptions" );
					expect( callLog.HTTPMethod ).toBe( "POST" );
					expect( callLog.contentType ).toBe( "multipart/form-data" );
					expect( callLog.payload.file ).toInclude( "somefile.mp3" );
				} );
			} );

			describe( "audio translation", function() {
				it( "returns a generated translation", function() {
					openAIService.$( "performHTTPRequest", {
						"status_code": 200,
						"fileContent": serializeJson( {
							"text": "Hello there"
						} )
					} );
					var result = openAIService.createAudioTranslation( file=expandPath( "somefile.mp3" ) );
					var callLog = openAIService.$callLog().performHTTPRequest[ 1 ];
					expect( callLog.endpoint ).toBe( "https://api.openai.com/v1/audio/translations" );
					expect( callLog.HTTPMethod ).toBe( "POST" );
					expect( callLog.contentType ).toBe( "multipart/form-data" );
					expect( callLog.payload.file ).toInclude( "somefile.mp3" );
				} );
			} );

		} );
	}

}
