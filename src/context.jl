mutable struct Context
    project_name::String
    project_description::String

    directories::Vector{AbstractString}
    files::Vector{AbstractString}

    functions::Vector{AbstractString}

    dir_descriptions::Dict{AbstractString,AbstractString}
    file_descriptions::Dict{AbstractString,AbstractString}
    func_descriptions::Dict{AbstractString,AbstractString}
end

function Context()
    Context(
        "",
        "",
        [],
        [],
        [],
        Dict(),
        Dict(),
        Dict()
    )
end

