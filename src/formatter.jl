using JSON3

function Base.print(io::IO, context::Context)
    JSON3.pretty(io, context)
end

function Base.print(context::Context)
    io = IOBuffer()
    print(io, context)
    return String(take!(io))
end
