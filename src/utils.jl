using JSON3

should_path_be_processed(path::AbstractString) =
    any(startswith("."), splitpath(path))

const KNOWN_PROJECT_FILE_NAMES = [
    "Project.toml"
    "Cargo.toml"
    "build.gradle"
    "settings.gradle"
    "Gemfile"
] |> Set

is_project_file(fn::AbstractString) =
    splitpath(fn)[end] in KNOWN_PROJECT_FILE_NAMES

"""
Converting Dict to a String
"""
function dict_to_string(dict::Dict{T,T} where {T<:AbstractString}, separator="")
    parts = String[]
    for (key, value) in dict
        push!(parts, "$(key): $(value)")
    end
    dict_string = separator == "" ? join(parts, ", \n") : join(parts, ", \n" * separator * "\n")
    return dict_string
end

vector_to_string(vec::Vector{T}, separator="") where {T<:AbstractString} =
    separator == "" ? join(vec, ", \n") : join(vec, ", \n" * separator * "\n")

function json_to_text(json_data::AbstractDict)
    io = IOBuffer()
    JSON3.pretty(io, json_data, JSON3.AlignmentContext(alignment=:Colon, indent=4))
    return String(take!(io))
end
