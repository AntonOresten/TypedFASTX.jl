const FASTXReaders = Union{FASTA.Reader, FASTQ.Reader}
const SANGER = FASTQ.SANGER_QUAL_ENCODING

# Q and R are either {NoQuality, FASTA.Reader} or {QualityScores, FASTQ.Reader} 
mutable struct TypedReader{T, Q <: AbstractQuality, R <: FASTXReaders}
    path::String
    reader::R
    position::Int
    encoding::QualityEncoding

    # For FASTA files
    # encoding is unused to increase type stability
    function TypedReader{T, NoQuality}(path::String, attach_index::Bool=false) where T
        io = open(path)
        reader = FASTA.Reader(open(path))
        if attach_index
            index = faidx(io)
            FASTA.index!(reader, index)
            seekrecord(reader, 1)
        end
        tr = new{T, NoQuality, FASTA.Reader}(path, reader, 1, SANGER)
        finalizer(close, tr)
        tr
    end

    # For FASTQ files
    function TypedReader{T, QualityScores}(path::String, encoding::QualityEncoding = SANGER) where T
        reader = FASTQ.Reader(open(path))
        tr = new{T, QualityScores, FASTQ.Reader}(path, reader, 1, encoding)
        finalizer(close, tr)
        tr
    end
end

Base.close(tr::TypedReader) = close(tr.reader)
Base.eltype(::Type{TypedReader{T, Q}}) where {T, Q} = TypedRecord{T, Q}

has_index(tr::TypedReader{T, NoQuality, FASTA.Reader}) where T = !isnothing(tr.reader.index)
Base.length(tr::TypedReader{T, NoQuality, FASTA.Reader}) where T = has_index(tr) ? length(tr.reader.index.lengths) : error("Length cannot be determined without an index.")
Base.size(tr::TypedReader{T, NoQuality, FASTA.Reader}) where T = has_index(tr) ? (length(tr.reader.index.lengths), ) : error("Size cannot be determined without an index.")
Base.firstindex(tr::TypedReader{T, NoQuality, FASTA.Reader}) where T = 1
Base.lastindex(tr::TypedReader{T, NoQuality, FASTA.Reader}) where T = length(tr)

# NoQuality

import FASTX: seekrecord

function seekrecord(tr::TypedReader{T, NoQuality, FASTA.Reader}, i::Integer) where T
    seekrecord(tr.reader, i)
    tr.position = i
end

function Base.getindex(tr::TypedReader{T, NoQuality, FASTA.Reader}, s::AbstractString) where T
    TypedRecord{T}(tr.reader[s])
end

function Base.getindex(tr::TypedReader{T, NoQuality, FASTA.Reader}, i::Integer) where T
    seekrecord(tr, i)
    TypedRecord{T}(first(tr.reader))
end

function Base.getindex(tr::TypedReader{T, NoQuality, FASTA.Reader}, inds::Array{<:Integer}) where T
    TypedRecord{T}[tr[i] for i in inds]
end

function Base.getindex(tr::TypedReader{T, NoQuality, FASTA.Reader}, r::UnitRange{<:Integer}) where T
    (r.start < 1 || r.stop > length(tr)) && error("Indices outside of range $(1:length(lazy))")
    seekrecord(tr, r.start)
    [TypedRecord{T}(record) for (i, record) in zip(r, tr.reader)]
end

function Base.iterate(tr::TypedReader{T, NoQuality, FASTA.Reader}) where T
    tr.position += 1
    record_state = iterate(tr.reader)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = TypedRecord{T}(record)
    (typed_record, new_state)
end

function Base.iterate(tr::TypedReader{T, NoQuality, FASTA.Reader}, state) where T
    tr.position += 1
    record_state = iterate(tr.reader, state)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = TypedRecord{T}(record)
    (typed_record, new_state)
end

# QualityScores

# Define Base.getindex(reader::TypedRecord{T, QualityScores}...) using ReadDatastores?

function Base.iterate(tr::TypedReader{T, QualityScores, FASTQ.Reader}) where T
    tr.position += 1
    record_state = iterate(tr.reader)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = TypedRecord{T}(record)
    (typed_record, new_state)
end

function Base.iterate(tr::TypedReader{T, QualityScores, FASTQ.Reader}, state) where T
    tr.position += 1
    record_state = iterate(tr.reader, state)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = TypedRecord{T}(record)
    (typed_record, new_state)
end


function Base.in(record::TypedRecord, tr::TypedReader{T, NoQuality, FASTA.Reader}) where T
    if !(record isa TypedRecord{T})
        return false
    end
    if !has_index(tr)
        error("Can't check if $record is in TypedReader because it does not have an index.")
    end
    id = identifier(record)
    haskey(tr.reader.index.names, id)
end

# Need different methods depending on Q because if Q isn't NoQuality, encoding_name argument is needed

# read_fasta and read_fastq calls TypedReader accordingly
# readdatastore field?
# readdatastores creates fastq ds file. do we need to change the functions?