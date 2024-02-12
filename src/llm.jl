using OpenAI
using JSON3
using Mocking

include("prompts.jl")

const API_KEY::Ref{String} = ""

set_api_key(secret) = API_KEY[] = secret

"""
Text generation based on model and output format.
models: 
* gpt-4-1106-preview
* gpt-3.5-turbo-1106
"""
function generate_text(
    system_prompt, prompt;
    format=:json, model="gpt-4-1106-preview"
)
    r = nothing

    # Setting system and user prompts
    system_dict = Dict("role" => "system", "content" => system_prompt)
    user_dict = Dict("role" => "user", "content" => prompt)
    prompts_dicts = [system_dict, user_dict]

    # Generating text 
    if format == :json
        r = @mock create_chat(
            API_KEY[],
            model,
            prompts_dicts;
            response_format=Dict("type" => "json_object"))
    else
        r = @mock create_chat(
            API_KEY[],
            model,
            prompts_dicts)
    end

    res = r.response[:choices][begin][:message][:content] |> JSON3.read
    return res
end

function fill_project_description!(
    context::Context,
    project_files::Dict{<:AbstractString,<:AbstractString})

    @info "Describing project"
    replacements = project_replacements(project_files)

    system_prompt = get_prompts("system_prompt.txt")
    project_prompt = get_prompts("project_prompt.txt", replacements)

    json_res = generate_text(system_prompt, project_prompt)
    @debug json_res

    context.project_name = get(json_res, "Project name", "")
    context.project_description = json_to_text(json_res)
end

function describe_dir(context::Context, dir_name::String, files::Vector{AbstractString})::String
    @info "Describing directory: $dir_name"
    replacements = dir_replacements(dir_name, files, context.project_description)

    system_prompt = get_prompts("system_prompt.txt")
    dir_prompt = get_prompts("directory_prompt.txt", replacements)

    json_res = generate_text(system_prompt, dir_prompt)
    @debug json_res

    context.dir_descriptions[dir_name] = json_to_text(json_res)
end

function describe_file(context::Context, fn::String, text::String)::String
    @info "Describing file: $fn"
    dir_name = dirname(fn)
    if isempty(dir_name)
        dir_name = "."
    end

    replacements = file_replacements(fn, text, context.project_description, context.dir_descriptions[dir_name])

    system_prompt = get_prompts("system_prompt.txt")
    file_prompt = get_prompts("file_prompt.txt", replacements)

    json_res = generate_text(system_prompt, file_prompt)
    @debug json_res

    context.file_descriptions[fn] = json_to_text(json_res)
end
