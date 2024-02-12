module CodeDescriber

export walk, print, set_api_key

include("utils.jl")
include("context.jl")
include("llm.jl")
include("crawler_fs.jl")
include("formatter.jl")

function __init__()
    api_key = get(ENV, "OPENAI_API_KEY", nothing)
    isnothing(api_key) || set_api_key(api_key)
end

end
