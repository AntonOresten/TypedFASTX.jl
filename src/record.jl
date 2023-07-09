"""
    TypedRecord{T}

    
    TypedRecord{T}(id::S, seq::T, qual::Q = nothing) where {S, T, Q}

constructs a `TypedRecord` with given id, seq, and optional qual.

    TypedRecord(id::S, seq::T, qual::Q = nothing) where {S, T, Q}`

constructs a `TypedRecord` with the type of seq inferred from the input.

    TypedRecord{T}(id::S, seq::t, qual::Q = nothing) where {S, T, t, Q}`

constructs a `TypedRecord` with seq coerced to type `T`.
    
    TypedRecord{T}(record::TypedRecord{t}) where {T, t}

converts an existing `TypedRecord` to a new `TypedRecord` with sequence type `T`.

A type to represent a generic biological sequence record. 

### Fields
- `identifier::String`: The unique identifier for the sequence.
- `sequence::T`: The biological sequence. It can be of type, including: `String`, `LongDNA{4}`, `LongRNA{4}` or `LongAA`.
- `quality::Union{Nothing, QualityScores}`: The quality scores associated with the sequence. `Nothing` indicates absence of quality scores.
"""
struct TypedRecord{T, Q <: QualityTypes}
    identifier::String
    sequence::T
    quality::Q

    function TypedRecord{T}(id::AbstractString, seq::T, qual::Any = NO_QUALITY) where {T}
        if qual isa NoQuality
            return new{T, NoQuality}(id, seq, qual)
        else
            qs = QualityScores(qual)
            seq_len, qs_len = length(seq), length(qs)
            @assert seq_len == qs_len "$(TypedRecord{T}) \"$id\": sequence length ($seq_len) does not match quality length ($qs_len)."
            return new{T, typeof(qs)}(id, seq, qs)
        end
    end

    function TypedRecord(id::AbstractString, seq::T, qual::Any = NO_QUALITY) where {T}
        TypedRecord{T}(id, seq, qual)
    end

    function TypedRecord{T}(id::AbstractString, seq::Any, qual::Any = NO_QUALITY) where {T}
        TypedRecord{T}(id, T(seq), qual)
    end

    function TypedRecord{T}(record::TypedRecord{t}) where {T, t}
        TypedRecord{T}(record.identifier, record.sequence, record.quality)
    end
end

const StringRecord = TypedRecord{String}
const DNARecord = TypedRecord{LongDNA{4}}
const RNARecord = TypedRecord{LongRNA{4}}
const AARecord = TypedRecord{LongAA}

Base.hash(r::TypedRecord, h::UInt) = hash(r.identifier, hash(r.sequence, hash(r.quality, h)))
Base.:(==)(r1::TypedRecord, r2::TypedRecord) = hash(r1) == hash(r2)

Base.length(record::TypedRecord) = length(record.sequence)

import FASTX: identifier, sequence, quality

identifier(record::TypedRecord) = record.identifier

sequence(record::TypedRecord) = record.sequence
sequence(::Type{T}, record::TypedRecord) where T = T(record.sequence)

quality(record::TypedRecord) = record.quality
has_quality(record::TypedRecord) = !isnothing(record.quality)
quality_values(record::TypedRecord) = has_quality(record) ? record.quality.values : nothing

"""
    error_prob_generator(record::TypedRecord)

Creates a generator of error probabilities for each character in the sequence.
"""
error_prob_generator(record::TypedRecord) = has_quality(record) ? error_prob_generator(record.quality) : nothing

"""
    error_rate_generator(record::TypedRecord)

Creates a vector of error probabilities for each character in the sequence.
"""
error_probs(record::TypedRecord) = has_quality(record) ? error_probs(record.quality) : nothing

"""
    error_rate(fastq_record::FASTQRecord)

Returns the error rate of a record with quality scores.
"""
error_rate(record::TypedRecord) = has_quality(record) ? error_rate(record.quality) : nothing
