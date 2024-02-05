function fill_project_description!(
    context::Context,
    project_files::Dict{<:AbstractString,<:AbstractString})

    @info project_files
end

function describe_dir(context::Context, dir_name::String, files::Vector{AbstractString})::String
    @info "Describing directory: $dir_name"
    ""
end

function describe_file(context::Context, fn::String, text::String)::String
    @info "Describing file: $fn"
    ""
end
