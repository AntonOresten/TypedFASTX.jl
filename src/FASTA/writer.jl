"""
    TypedFASTA.Writer{T}

A typed FASTA writer. `T` is the type of the sequence.
"""
mutable struct Writer{T} <: AbstractWriter{T}
    path::String
    io::IO
    position::Int

    function Writer{T}(io::IO; path::String = "no path") where T
        w = new{T}(path, io, 1)
        finalizer(close, w)
        w
    end

    function Writer{T}(path::String; append::Bool=false) where T
        io = open(path, append ? "a" : "w")
        Writer{T}(io; path=path)
    end
end

function Base.write(w::Writer{T}, record::Record{T}) where T
    print(w.io, record)
    w.position += 1
    record
end

Base.write(w::Writer{T}, record::AbstractRecord{T}) where T = write(w, convert(Record{T}, record))