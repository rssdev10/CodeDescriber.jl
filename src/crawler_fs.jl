function walk(entry_dir::String; output=:file)::Context
    context = Context()

    @info "Scan directory $entry_dir"

    normalized_entry_dir = normpath(entry_dir)
    ned_len = length(normalized_entry_dir) + 1

    project_files = String[]
    for (root, dirs, files) in walkdir(normalized_entry_dir)
        cur_dir = root[ned_len:end]
        should_path_be_processed(cur_dir) && continue

        println("Directories in $root")
        for dir in dirs
            push!(context.directories, joinpath(root, dir)[ned_len:end])
            # println(joinpath(root, dir)[ned_len:end])
        end
        println("Files in $root")
        for file in files
            fn_path = joinpath(root, file)
            push!(context.files, fn_path[ned_len:end])
            is_project_file(file) && push!(project_files, fn_path)
            # println(fn_path[ned_len:end])
        end

        if !isempty(project_files)
            fill_project_description!(
                context,
                Dict(
                    fn => open(f -> read(f, String), fn)
                    for fn in project_files
                )
            )

            empty!(project_files)
        end
    end

    push!(context.directories, ".")

    for dir in sort(context.directories)
        files = if isequal(dir, ".")
            filter(fn -> length(splitpath(fn)) === 1, context.files)
        else
            filter(startswith(dir), context.files)
        end
        context.dir_descriptions[dir] = describe_dir(context, dir, files)
    end

    context.file_descriptions = Dict(
        fn => describe_file(
            context,
            fn,
            open(f -> read(f, String), joinpath(normalized_entry_dir, fn))
        )
        for fn in sort(context.files)
    )

    return context
end
