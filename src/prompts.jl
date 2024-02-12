using Mustache


"""
Reading prompt from the .txt file
"""
load_prompts(filename)::Mustache.MustacheTokens =
    joinpath(@__DIR__, "..", "resources", "prompts", filename) |>
    filepath -> Mustache.load(filepath)

function project_replacements(project_files)
    project_content = dict_to_string(project_files, "\n---------\n")
    return Dict("project_content" => project_content)
end

function dir_replacements(dir_name::String, files::Vector{AbstractString}, project_overview)
    directory_content = vector_to_string(files, "\n---------\n")
    return Dict(
        "dir_name" => dir_name,
        "directory_content" => directory_content,
        "project_overview" => project_overview
    )
end

function file_replacements(fn::String, file_content::String, project_overview_path::AbstractString, dir_overview::AbstractString)
    return Dict(
        "file_name" => fn,
        "file content" => file_content,
        "directory_content" => dir_overview,
        "project_overview" => project_overview_path
    )
end

"""
Replacement part of the prompt with the specific contextual information
"""
function get_prompts(prompt_fn::AbstractString, replacements::Dict{T,T})::String where {T<:AbstractString}
    tpl = load_prompts(prompt_fn)
    return Mustache.render(tpl, replacements)
end

const EMPTY_REPLACEMENTS = Dict{String,String}()
get_prompts(prompt_fn::AbstractString) = get_prompts(prompt_fn, EMPTY_REPLACEMENTS)
