using JSON3
using Mocking
using OpenAI: create_chat

haskey(ENV, "OPENAI_API_KEY") || Mocking.activate()

chat_response = JSON3.read("""{
    "id":"chatcmpl-8rDzl0oHN5SZswxOK3aJfckuBnW91",
    "object":"chat.completion",
    "created":1707695874,
    "model":"gpt-4-1106-preview",
    "choices":[
        {
        "index":0,
        "message":{
            "role":"assistant",
            "content":"{\\n    \\"Project name\\": \\"CodeDescriber\\",\\n    \\"Project Purpose\\": \\"To generate concise and comprehensive documentation for Julia coding projects, enhancing readability and maintainability of the codebase.\\",\\n    \\"Key Functionalities\\": [\\n        \\"Analysis of project directories and source files\\",\\n        \\"Extraction of key components, modules, and classes\\",\\n        \\"Summarization of project objectives through code and comments\\",\\n        \\"Identification of primary features from the code and inline documentation\\",\\n        \\"Documentation output in professional and clear language\\"\\n    ],\\n    \\"Technology Stack\\": \\"The project is implemented in Julia, utilizing JSON3 for JSON handling, Mocking for test mocking, Mustache for templating, and the OpenAI framework.\\"\\n}"
        },
        "logprobs":"",
        "finish_reason":"stop"
    }
    ],
    "usage":{
        "prompt_tokens":840,
        "completion_tokens":145,
        "total_tokens":985
    },
    "system_fingerprint":"fp_c3e45ce344"
}""")

patch_create_chat = @patch create_chat(api_key::String, model_id::String, messages; response_format=Dict()) =
    (status=200, response=chat_response)
