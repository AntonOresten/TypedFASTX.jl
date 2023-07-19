const FASTXWriter = Union{FASTA.Writer, FASTQ.Writer}

mutable struct TypedWriter{T, Q <: AbstractQuality}
    path::String
    io::IO
    position::Int

    function TypedWriter{T, Q}(io::IO) where {T, Q}
        tw = new{T, Q}("no path", io, 1)
        finalizer(close, tw)
        tw
    end

    function TypedWriter{T, Q}(path::String; append::Bool=false) where {T, Q <: AbstractQuality}
        io = open(path, append ? "a" : "w")
        tw = new{T, Q}(path, io, 1)
        finalizer(close, tw)
        tw
    end
end

Base.close(tw::TypedWriter) = close(tw.io)

# print is probably reeeaally sloow. TranscodingStream faster? or convert to FASTXRecord first?
print_fasta(io::IO, record::TypedRecord{T, Q}) where {T, Q} = print(io, ">$(identifier(record))\n$(sequence(record))")
print_fastq(io::IO, record::TypedRecord{T, QualityScores}) where T = print(io, "@$(identifier(record))\n$(sequence(record))\n+\n$(quality(record))")

function Base.write(tw::TypedWriter{T, NoQuality}, record::TypedRecord{T, Q}) where {T, Q}
    print_fasta(tw.io, record)
    print(tw.io, '\n')
    tw.position += 1
    record
end

function Base.write(tw::TypedWriter{T, QualityScores}, record::TypedRecord{T, QualityScores}) where T
    print_fastq(tw.io, record)
    print(tw.io, '\n')
    tw.position += 1
    record
end