# CBOPENAI

[![cbopenai CI](https://github.com/coldbox-modules/cbopenai/actions/workflows/ci.yml/badge.svg?branch=development)](https://github.com/coldbox-modules/cbopenai/actions/workflows/ci.yml)

CBOPENAI is a module that provides a simple API to access OpenAI's variety of AI services.

## Requirements

-   Adobe CF 2018+ or Lucee 5+
-   ColdBox 6+

## Installation

Install [CommandBox](https://www.ortussolutions.com/products/commandbox), then from your terminal, run:

```bash
# Install latest stable version
box install cbopenai
# Install bleeding edge
box install cbopenai@be
```

## Service Object
CBOPENAI comes with a service object you can use for all operations.
```javascript
// Using WireBox injection
property name="openAIService" inject="OpenAIService@cbopenai";
// Using getInstance
var openAIService = getInstance( "OpenAIService@cbopenai" );
```

## Usage

### getModels
List and describe the various models available in the API. You can refer to the Models documentation to understand what models are available and the differences between them.
```javascript
function getModels()

var models = openAIService.getModels();
```

### getModel
Retrieves a model instance, providing basic information about the model such as the owner and permissioning.
```javascript
function getModel( required string model )

var model = openAIService.getModel( "text-davinci-003" );
```

### createModeration
Classifies if text violates OpenAI's Content Policy
```javascript
function createModeration( required string input )

var moderation = openAIService.createModeration( input="I'm going to murder that sandwhich later." );
```

### createCompletion
Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.

```javascript
function createCompletion(
    required any prompt,
    string model = "text-davinci-003",
    string suffix,
    numeric maxTokens,
    numeric temperature,
    numeric topP,
    numeric n, 
    boolean stream,
    numeric logprops,
    boolean echo,
    any stop,
    numeric presencePenalty,
    numeric frequencyPenalty,
    numeric bestOf,
    struct logitBias,
    string user
)

var completion = openAIService.createCompletion( prompt="What is 2+2?" );
```

### createChatCompletion
Given a list of messages describing a conversation, the model will return a response.
```javascript
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
)

var completion = openAIService.createChatCompletion(
    messages = [
        {
            "role": "user",
            "content": "Hello!"
        }
    ]
)
```

### createImage
Creates an image given a prompt.
```javascript
function createImage(
    required string prompt,
    numeric n,
    string size,
    string response_format,
    string user
)

var images = openAIService.createImage( prompt="A cat with a funny hat.", n=2 ); // create 2 images
```

### createImageEdit
Creates an edited or extended image given an original image and a prompt.
```javascript
function createImageEdit(
    required string image,
    string mask,
    string prompt,
    numeric n,
    string size,
    string response_format,
    string user
)

var image = openAIService.createImageEdit( image=expandPath( "somefile.png" ) );
```

### createImageVariation
Creates a variation of a given image.
```javascript
function createImageVariation(
    required string image,
    numeric n,
    string size,
    string response_format,
    string user
)

var image = openAIService.createImageVariation( image=expandPath( "somefile.png" ) );
```

### createEdit
Given a prompt and an instruction, the model will return an edited version of the prompt.
```javascript
function createEdit(
    string model = "text-davinci-edit-001",
    string input,
    string instruction,
    numeric n,
    numeric temperature,
    numeric top_p
)

var edit = openAIService.createEdit(
    input="What day of the wek is it?",
    instruction="Fix the spelling mistakes."
);
```

### createdEmbedding
Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.
```javascript
function createEmbedding(
    required any input,  
    model = "text-embedding-ada-002",
    string user        
)

var embedding = openAIService.createEmbedding( input="The food was delicious and the waiter..." );
```

### createAudioTranscription
Transcribes audio into the input language.

```javascript
function createAudioTranscription(
    required string file,
    required string model = "whisper-1",
    string prompt,
    string response_format,
    numeric temperature,
    string language
)

var text = openAIService.createAudioTranscription(
    file = expandPath( "/includes/audio/obi_wan_hello_there.mp3" )
); 
```

### createAudioTranslation
Translates audio into into English.

```javascript
function createAudioTranslation(
    required string file,
    required string model = "whisper-1",
    string prompt,
    string response_format,
    numeric temperature
)

var text = openAIService.createAudioTranslation(
    file = expandPath( "/includes/audio/german.mp3" )
); 
```

## Examples

Included in this repo is an app where you can experience and see code examples covering all the features of CBOPENAI.

Just run the following from the `test-harness` directory:

```
box install && cd .. && box server start
```

Then visit:

http://localhost:60299/


## Contributing

We love PRs! Please create a ticket using the [ Issue Tracker](https://github.com/coldbox-modules/cbopenai/issues) before submitting a PR.

## Test Harness

There is a test harness application included in this repo.

To start the test harness:

```
cd test-harness
box install
box server start
```

This will start the test harness using a random port selected by CommandBox. For example, if the random port selected is 60299, you can run the test suite using http://127.0.0.1:60299/tests.

## License

Apache License 2.0

## Credits

The CBOPENAI module for ColdBox is written and maintained by [Grant Copley](https://twitter.com/grantcopley) and [Ortus Solutions](https://www.ortussolutions.com/).

## Project Support

If CBOPENAI makes you happy, please consider becoming an Ortus [Patreon supporter](https://www.patreon.com/ortussolutions).

## Resources

-   Docmentation: https://github.com/coldbox-modules/cbopenai
-   API Docs: https://apidocs.ortussolutions.com/#/coldbox-modules/cbopenai/
-   GitHub Repository: https://github.com/coldbox-modules/cbopenai
-   Issue Tracker: https://github.com/coldbox-modules/cbopenai/issues
-   ITB 2023 Practical AI session: https://docs.google.com/presentation/d/1xXlGBs_kNZhrAgS8xxJ4T5NFev2nH4FAaZ3DXYt8wqQ/edit?usp=sharing
