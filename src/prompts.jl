using JSON


"""
Reading peompt from the .txt file
"""
get_prompt(filename) = 
    joinpath(@__DIR__, "..", "resources", "prompts", filename) |> 
    filepath -> read(filepath, String)

function project_replacements(project_files)
    project_content = dict_to_string(project_files, "\n---------\n")
    return Dict("project_content" => project_content)
end

function dir_replacements(dir_name::String, files::Vector{AbstractString}, project_overview)
    directory_content = vector_to_string(files, "\n---------\n")
    return Dict("dir_name" => dir_name, 
                "directory_content" => directory_content,
                "project_overview" => project_overview)
end

function file_replacements(fn::String, text::String, project_overview_path::AbstractString, dir_overview::AbstractString)
    return Dict("file_name" => fn,
                "file content" => file_content, 
                "directory_content" => directory_content,
                "project_overview" => project_overview)
end

"""
Replacement part of the prompt with the specific contextual information
"""
function replace_placeholders(prompt::AbstractString, replacements::Dict{T, T} where T <: AbstractString)
    for (placeholder, replacement) in replacements
        prompt = replace(prompt, "\$$placeholder" => replacement)
    end
    return prompt
end

