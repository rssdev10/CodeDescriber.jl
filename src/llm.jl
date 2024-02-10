using OpenAI

"""
Text generation based on model and output format.
models: 
* gpt-4-1106-preview
* gpt-3.5-turbo-1106
"""
function generate_text(system_prompt, prompt; format=:json, model="gpt-4-1106-preview")
  r = nothing

  # Setting system and user prompts
  system_dict = Dict("role" => "system", "content"=> system_prompt)
  user_dict =  Dict("role" => "user", "content"=> prompt)
  prompts_dicts = [system_dict, user_dict]

  # Generating text 
  if format == :json
    r = create_chat(secret_key,  
                    model,
                    prompts_dicts;
                    response_format=Dict( "type"=> "json_object" ))
  else
    r = create_chat(secret_key, 
                    model,
                    prompts_dicts)
  end 
  res = r.response[:choices][begin][:message][:content]
  return res
end

function fill_project_description!(
    context::Context,
    project_files::Dict{<:AbstractString,<:AbstractString})

    @info "Describing project"
    replacements = project_replacements(project_files)
    
    
    system_prompt = get_prompt("system_prompt.txt")
    project_prompt = get_prompt("project_prompt.txt")
    project_prompt = replace_placeholders(project_prompt, replacements)

    json_res = generate_text(system_prompt, project_prompt) 
    context.project_name = json_res["Project Name"]
    context.project_description = json_to_text(json_res)
end

function describe_dir(context::Context, dir_name::String, files::Vector{AbstractString})::String
    @info "Describing directory: $dir_name"
    replacements = dir_replacements(dir_name, files, context.project_description)

    system_prompt = get_prompt("system_prompt.txt")
    dir_prompt = get_prompt("directory_prompt.txt")
    dir_prompt = replace_placeholders(dir_prompt, replacements)

    json_res = generate_text(system_prompt, dir_prompt) 
    context.dir_descriptions[dir_name] = json_to_text(json_res)
end

function describe_file(context::Context, fn::String, text::String)::String
    @info "Describing file: $fn"
    dir_name = dirname(fn)
    replacements = file_replacements(fn, text, context.project_description, context.dir_descriptions[dir_name])

    system_prompt = get_prompt("system_prompt.txt")
    file_prompt = get_prompt("file_prompt.txt")
    file_prompt = replace_placeholders(file_prompt, replacements)

    json_res = generate_text(system_prompt, file_prompt) 
    context.file_descriptions[fn] = json_to_text(json_res)
end
