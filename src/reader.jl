const FASTXReaders = Union{FASTA.Reader, FASTQ.Reader}
const SANGER = FASTQ.SANGER_QUAL_ENCODING

mutable struct TypedReader{T, Q <: AbstractQuality}
    path::String
    reader::FASTXReaders
    position::Int
    encoding::QualityEncoding

    # For FASTA files
    # encoding is unused to increase type stability
    function TypedReader{T, NoQuality}(path::String, create_index::Bool=false) where T
        io = open(path)
        reader = FASTA.Reader(open(path), copy=false)
        if create_index
            index = faidx(io)
            FASTA.index!(reader, index)
            seekrecord(reader, 1)
        end
        tr = new{T, NoQuality}(path, reader, 1)
        finalizer(close, tr)
        tr
    end

    # For FASTQ files
    function TypedReader{T, QualityScores}(path::String, encoding::QualityEncoding = SANGER) where T
        reader = FASTQ.Reader(open(path), copy=false)
        tr = new{T, QualityScores}(path, reader, 1)
        tr.encoding = encoding
        finalizer(close, tr)
        tr
    end
end

function Base.show(io::IO, tr::TypedReader{T, Q}) where {T, Q}
    print(io, "$(TypedReader{T, Q})")
    print(io, "\n  path: ", repr(tr.path))
    print(io, "\n  position: ", tr.position)
end

# delete readdatastore file in the fastq typed reader finalizer
#=function close(tr::TypedReader{T, Q, R}) where {T, Q, R}
    close(tr.reader)
    if tr.reader isa FASTQ.Reader
        path = "$(tr.path).ds"
        isfile(path) && rm(path)
    end
end=#

Base.close(tr::TypedReader) = close(tr.reader)
Base.eltype(::TypedReader{T, Q}) where {T, Q} = TypedRecord{T, Q}
Base.eltype(::Type{<:TypedReader{T, Q}}) where {T, Q} = TypedRecord{T, Q}

has_index(tr::TypedReader{T, NoQuality}) where T = !isnothing(tr.reader.index)
Base.length(tr::TypedReader{T, NoQuality}) where T = has_index(tr) ? length(tr.reader.index.lengths) : error("Length cannot be determined without an index.")
Base.size(tr::TypedReader{T, NoQuality}) where T = has_index(tr) ? (length(tr.reader.index.lengths), ) : error("Size cannot be determined without an index.")
Base.firstindex(tr::TypedReader{T, NoQuality}) where T = has_index(tr) ? 1 : error("Reader doesn't have an index.")
Base.lastindex(tr::TypedReader{T, NoQuality}) where T = has_index(tr) ? length(tr) : error("Reader doesn't have an index.")
Base.eachindex(tr::TypedReader{T, NoQuality}) where T = has_index(tr) ? (firstindex(tr):lastindex(tr)) : error("Reader doesn't have an index.")

# NoQuality

import FASTX: seekrecord

function seekrecord(tr::TypedReader{T, NoQuality}, i::Integer) where T
    seekrecord(tr.reader, i)
    tr.position = i
end

function Base.getindex(tr::TypedReader{T, NoQuality}, s::AbstractString) where T
    TypedRecord{T}(tr.reader[s])
end

function Base.getindex(tr::TypedReader{T, NoQuality}, i::Integer) where T
    seekrecord(tr, i)
    TypedRecord{T}(first(tr.reader))
end

function Base.getindex(tr::TypedReader{T, NoQuality}, inds::Array{<:Integer}) where T
    (minimum(inds) < 1 || maximum(inds) > length(tr)) && error("Some indices outside of range $(1:length(tr))")
    TypedRecord{T}[tr[i] for i in inds]
end

function Base.getindex(tr::TypedReader{T, NoQuality}, r::UnitRange{<:Integer}) where T
    (r.start < 1 || r.stop > length(tr)) && error("Some indices outside of range $(1:length(tr))")
    seekrecord(tr, r.start)
    [TypedRecord{T}(record) for (i, record) in zip(r, tr.reader)]
end

function Base.iterate(tr::TypedReader{T, NoQuality}) where T
    tr.position += 1
    record_state = iterate(tr.reader)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = TypedRecord{T}(record)
    (typed_record, new_state)
end

function Base.iterate(tr::TypedReader{T, NoQuality}, state) where T
    tr.position += 1
    record_state = iterate(tr.reader, state)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = TypedRecord{T}(record)
    (typed_record, new_state)
end

# QualityScores

# Define Base.getindex(reader::TypedRecord{T, QualityScores}...) using ReadDatastores?

function Base.iterate(tr::TypedReader{T, QualityScores}) where T
    tr.position += 1
    record_state = iterate(tr.reader)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = TypedRecord{T}(record)
    (typed_record, new_state)
end

function Base.iterate(tr::TypedReader{T, QualityScores}, state) where T
    tr.position += 1
    record_state = iterate(tr.reader, state)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = TypedRecord{T}(record)
    (typed_record, new_state)
end


function Base.in(record::TypedRecord, tr::TypedReader{T, NoQuality}) where T
    if !(record isa TypedRecord{T})
        return false
    end
    if !has_index(tr)
        error("Can't check if $record is in TypedReader because it does not have an index.")
    end
    haskey(tr.reader.index.names, identifier(record))
end

# take n records from a TypedReader
function take(reader::TypedReader, n::Integer)
    records = Vector{eltype(reader)}()
    if n < 1
        return records
    end
    i = 0
    for record in reader
        push!(records, record)
        i += 1
        if i >= n
            break
        end
    end
    if i < n
        @warn "Reached end of file before taking $n records. $(length(records)) records taken from \"$(reader.path)\"."
    end
    records
end

# Need different methods depending on Q because if Q isn't NoQuality, encoding_name argument is needed

# read_fasta and read_fastq calls TypedReader accordingly
# readdatastore field?
# readdatastores creates fastq ds file. do we need to change the functions?