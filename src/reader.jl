const FASTXReader = Union{FASTA.Reader, FASTQ.Reader}
const SANGER = FASTQ.SANGER_QUAL_ENCODING

mutable struct TypedReader{T, Q <: AbstractQuality}
    path::String
    reader::FASTXReader
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

const TypedFASTAReader = TypedReader{T, NoQuality} where T
const TypedFASTQReader = TypedReader{T, QualityScores} where T

const StringReader = TypedReader{String}
const DNAReader = TypedReader{LongDNA{4}}
const RNAReader = TypedReader{LongRNA{4}}
const AAReader = TypedReader{LongAA}

function Base.summary(::TypedReader{T, Q}) where {T, Q}
    "$(TypedReader{T, Q})"
end

function Base.show(io::IO, tr::TypedReader{T, Q}) where {T, Q}
    print(io, "$(summary(tr))($(repr(tr.path)), $(tr.position))")
end

function Base.show(io::IO, ::MIME"text/plain", tr::TypedReader{T, Q}) where {T, Q}
    print(io, summary(tr))
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
Base.eltype(::Type{TypedReader{T, Q}}) where {T, Q} = TypedRecord{T, Q}

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
    typed_record = TypedRecord{T, QualityScores}(record, tr.encoding)
    (typed_record, new_state)
end

function Base.iterate(tr::TypedReader{T, QualityScores}, state) where T
    tr.position += 1
    record_state = iterate(tr.reader, state)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = TypedRecord{T, QualityScores}(record, tr.encoding)
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

function Base.in(record::TypedRecord, ::TypedReader{T, QualityScores}) where T
    error("Can't check if $record is in TypedReader because it wraps a FASTQ reader without an index.")
end

import FASTX: index!

function index!(tr::TypedReader{T, NoQuality}) where T
    if !has_index(tr)
        open(tr.path) do io
            index = faidx(io)
            FASTA.index!(tr.reader, index)
        end
    end
    tr
end


function Base.collect(tr::TypedReader;
    min_length::Integer = 0, max_length::Real = Inf
)
    records = collect(eltype(tr), tr.reader)
    filter!(r -> min_length <= length(r) <= max_length, records)
end

# take n records from a TypedReader
function Base.take!(reader::TypedReader, n::Real = Inf;
    min_length::Integer = 0, max_length::Real = Inf
)
    records = Vector{eltype(reader)}()
    if n < 1
        return records
    end
    i = 0
    for record in reader
        if !(min_length <= length(record) <= max_length)
            continue
        end
        push!(records, record)
        i += 1
        if i >= n
            break
        end
    end
    if i < n && !isinf(n)
        @warn "Reached end of file before taking $n records. $(length(records)) records taken from \"$(reader.path)\"."
    end
    records
end

# read_fasta and read_fastq calls TypedReader accordingly
# readdatastore field?
# readdatastores creates fastq ds file. do we need to change the functions?