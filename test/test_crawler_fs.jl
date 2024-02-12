using CodeDescriber

include("helpers/openai_mocking.jl")

entry_dir = normpath(joinpath(@__DIR__, ".."))

apply(patch_create_chat) do
    result = walk(entry_dir)

    open(joinpath("..", "result.json"), "w") do f
        print(f, result)
    end    
end
