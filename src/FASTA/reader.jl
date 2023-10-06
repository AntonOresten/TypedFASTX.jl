"""
    TypedFASTA.Reader{T}

A typed FASTA reader. `T` is the type of the sequence.
"""
mutable struct Reader{T} <: TypedReader{T}
    path::String
    reader::FASTX.FASTA.Reader
    position::Int

    function Reader{T}(path::String, create_index::Bool=false) where T
        io = open(path)
        reader = FASTX.FASTAReader(io, copy=false)
        if create_index
            index = FASTX.faidx(io)
            FASTX.FASTA.index!(reader, index)
            seekrecord(reader, 1)
        end
        new{T}(path, reader, 0)
    end
end

Base.eltype(::Reader{T}) where T = Record{T}
Base.eltype(::Type{Reader{T}}) where T = Record{T}

function Base.show(io::IO, reader::Reader{T}) where T
    print(io, "$(summary(reader))($(repr(reader.path)))")
end

function Base.show(io::IO, ::MIME"text/plain", reader::Reader{T}) where T
    print(io, summary(reader), " (FASTA):")
    print(io, "\n  path: ", repr(reader.path))
    print(io, "\n  position: ", reader.position)
end

has_index(reader::Reader{T}) where T = !isnothing(reader.reader.index)
Base.length(reader::Reader{T}) where T = has_index(reader) ? length(reader.reader.index.lengths) : error("Length cannot be determined without an index.")
Base.size(reader::Reader{T}) where T = has_index(reader) ? (length(reader.reader.index.lengths), ) : error("Size cannot be determined without an index.")
Base.firstindex(reader::Reader{T}) where T = has_index(reader) ? 1 : error("Reader doesn't have an index.")
Base.lastindex(reader::Reader{T}) where T = has_index(reader) ? length(reader) : error("Reader doesn't have an index.")
Base.eachindex(reader::Reader{T}) where T = has_index(reader) ? (firstindex(reader):lastindex(reader)) : error("Reader doesn't have an index.")

import FASTX: seekrecord

function seekrecord(reader::Reader{T}, i::Integer) where T
    seekrecord(reader.reader, i)
    reader.position = i - 1
end

function Base.getindex(reader::Reader{T}, s::AbstractString) where T
    convert(Record{T}, reader.reader[s])
end

function Base.getindex(reader::Reader{T}, i::Integer) where T
    seekrecord(reader, i)
    convert(Record{T}, first(reader.reader))
end

function Base.getindex(reader::Reader{T}, inds::Array{<:Integer}) where T
    (minimum(inds) < 1 || maximum(inds) > length(reader)) && error("Some indices outside of range $(1:length(reader))")
    Record{T}[convert(Record{T}, reader[i]) for i in inds]
end

function Base.getindex(reader::Reader{T}, r::UnitRange{<:Integer}) where T
    (r.start < 1 || r.stop > length(reader)) && error("Some indices outside of range $(1:length(reader))")
    seekrecord(reader, r.start)
    Record{T}[convert(Record{T}, record) for (_, record) in zip(r, reader.reader)]
end

function Base.iterate(reader::Reader{T}, state=0) where T
    reader.position += 1
    record_state = iterate(reader.reader, state)
    isnothing(record_state) && return nothing
    record, new_state = record_state

    try
        record = convert(Record{T}, record)
        return (record, new_state)
    catch e
        @warn "Skipping record at position $(reader.position) due to: $e"
        return iterate(reader, new_state)  # Skip this record and move to the next
    end
end



function Base.in(record::Record, reader::Reader{T}) where T
    if !(record isa Record{T})
        return false
    end
    if !has_index(reader)
        error("Can't check if $record is in TypedFASTX.FASTAReader because it does not have an index.")
    end
    haskey(reader.reader.index.names, description(record))
end

import FASTX: index!

function index!(reader::Reader{T}) where T
    if !has_index(reader)
        open(reader.path) do io
            index = FASTX.faidx(io)
            FASTX.FASTA.index!(reader.reader, index)
        end
    end
    reader
end

@inline function check_length(record::Record{T}, min_length::Int, max_length::Int) where T
    min_length <= length(record) <= max_length
end

# take n records from a Reader
function Base.take!(reader::Reader{T}, N::Int = typemax(Int);
    min_length::Int = 0, max_length::Int = typemax(Int)
) where T
    records = Vector{Record{T}}()
    if N < 1
        return records
    end
    i = 0
    for record in reader
        if !check_length(record, min_length, max_length)
            continue
        end
        push!(records, record)
        i += 1
        if i >= N
            break
        end
    end
    if i < N && N != typemax(Int)
        @warn "Reached end of file before taking $N records. $(length(records)) records taken from \"$(reader.path)\"."
    end
    records
end

# Define Base.getindex(reader::TypedFASTQRecord{T}...) using ReadDatastores?

# readdatastore field?
# readdatastores creates fastq ds file