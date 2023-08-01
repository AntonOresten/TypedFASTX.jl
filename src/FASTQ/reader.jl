"""
    TypedFASTQ.Reader{T}

A typed FASTQ reader. `T` is the type of the sequence.
"""
mutable struct Reader{T} <: AbstractReader{T}
    path::String
    reader::FASTX.FASTQ.Reader
    position::Int
    encoding::FASTX.QualityEncoding

    function Reader{T}(path::String, encoding::FASTX.QualityEncoding = FASTX.FASTQ.SANGER_QUAL_ENCODING) where T
        fq_reader = FASTX.FASTQ.Reader(open(path), copy=false)
        new{T}(path, fq_reader, 1, encoding)
    end
end

Base.close(reader::Reader) = close(reader.reader)

# delete readdatastore file in the fastq typed reader finalizer
#=function close(reader::Reader{T}) where T
    close(reader.reader)
    if has_readdatastore(reader.reader)
        path = "$(reader.path).ds"
        isfile(path) && rm(path)
    end
end=#

Base.eltype(::Reader{T}) where T = Record{T}
Base.eltype(::Type{Reader{T}}) where T = Record{T}

function Base.summary(R::Type{Reader{T}}) where T
    "$(R)"
end

function Base.show(io::IO, reader::Reader{T}) where T
    print(io, "$(summary(reader))($(repr(reader.path)))")
end

function Base.show(io::IO, ::MIME"text/plain", reader::Reader{T}) where T
    print(io, summary(reader), ':')
    print(io, "\n  path: ", repr(reader.path))
    print(io, "\n  position: ", reader.position)
end

function Base.iterate(reader::Reader{T}) where T
    reader.position += 1
    record_state = iterate(reader.reader)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = convert(Record{T}, record, reader.encoding)
    (typed_record, new_state)
end

function Base.iterate(reader::Reader{T}, state) where T
    reader.position += 1
    record_state = iterate(reader.reader, state)
    isnothing(record_state) && return nothing
    record, new_state = record_state
    typed_record = convert(Record{T}, record, reader.encoding)
    (typed_record, new_state)
end

function Base.in(record::Record, ::Reader{T}) where T
    error("Can't check if $record is in TypedFASTQ.Reader because it wraps a FASTX.FASTQ.Reader without an index.")
end

@inline function check_length(record::Record{T}, min_length::Int, max_length::Int) where T
    min_length <= length(record) <= max_length
end

@inline function check_error_rate(record::Record{T}, max_error_rate::Float64) where T
    error_rate(record) < max_error_rate
end

function Base.collect(reader::Reader{T};
    min_length::Int = 0, max_length::Int = typemax(Int), max_error_rate::Float64 = 1.0
) where T
    records = collect(eltype(reader), reader.reader)
    filter_func = isone(max_error_rate) ?
        (r -> check_length(r, min_length, max_length)) :
        (r -> check_length(r, min_length, max_length) && check_error_rate(r, max_error_rate))
    filter!(filter_func, records)
end

# take n records from a Reader
function Base.take!(reader::Reader{T}, n::Int = typemax(Int);
    min_length::Int = 0, max_length::Int = typemax(Int), max_error_rate::Float64 = 1.0
) where T
    records = Vector{Record{T}}()
    if n < 1
        return records
    end
    i = 0
    for record in reader
        if !(check_length(record, min_length, max_length) && check_error_rate(record, max_error_rate))
            continue
        end
        push!(records, record)
        i += 1
        if i >= n
            break
        end
    end
    if i < n && n != typemax(Int)
        @warn "Reached end of file before taking $n records. $(length(records)) records taken from \"$(reader.path)\"."
    end
    records
end