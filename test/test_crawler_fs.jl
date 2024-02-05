using CodeDescriber

entry_dir = normpath(joinpath(@__DIR__, ".."))

result = walk(entry_dir)
