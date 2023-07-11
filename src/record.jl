"""
    TypedRecord{T}

A type to represent a generic biological sequence record. 

### Fields
- `identifier::String`: The unique identifier for the sequence.
- `sequence::T`: The sequence itself. It can be of any type, including: `String`, `LongDNA{4}`, `LongRNA{4}` or `LongAA`.
- `quality::Union{NoQuality, QualityScores}`: The quality scores associated with the sequence. `Nothing` indicates absence of quality scores.

    TypedRecord{T}(id::AbstractString, seq::T, qual::Any = NO_QUALITY) where T

Constructs a `TypedRecord` with given id, seq, and optional qual.

    TypedRecord(id::AbstractString, seq::T, qual::Any = NO_QUALITY) where T

Constructs a `TypedRecord` with the type of seq inferred from the input.

    TypedRecord{T}(id::AbstractString, seq::Any, qual::Any = NO_QUALITY) where T

Constructs a `TypedRecord{T}` from a sequence that isn't type T. Tries to use the T(::typeof(seq)) method for converting.

    TypedRecord{T}(record::TypedRecord) where T

Converts an existing `TypedRecord` to a new `TypedRecord` with sequence type `T`.
"""
struct TypedRecord{T, Q <: AbstractQuality}
    identifier::String
    sequence::T
    quality::Q

    # When both record type and sequence type are specified
    function TypedRecord{T}(id::AbstractString, seq::T, qual::Any = NO_QUALITY) where T
        if qual isa NoQuality
            new{T, NoQuality}(id, seq, qual)
        else
            qs = QualityScores(qual)
            seq_len, qs_len = length(seq), length(qs)
            @assert seq_len == qs_len "$(TypedRecord{T}) \"$id\": sequence length ($seq_len) does not match quality length ($qs_len)."
            new{T, QualityScores}(id, seq, qs)
        end
    end

    # When record type isn't specified
    function TypedRecord(id::AbstractString, seq::T, qual::Any = NO_QUALITY) where T
        TypedRecord{T}(id, seq, qual)
    end

    # When sequence type isn't specified
    function TypedRecord{T}(id::AbstractString, seq::Any, qual::Any = NO_QUALITY) where T
        TypedRecord{T}(id, T(seq), qual)
    end

    function TypedRecord{T}(record::TypedRecord) where T
        TypedRecord{T}(record.identifier, record.sequence, record.quality)
    end
end

const StringRecord = TypedRecord{String}
const DNARecord = TypedRecord{LongDNA{4}}
const RNARecord = TypedRecord{LongRNA{4}}
const AARecord = TypedRecord{LongAA}

Base.hash(r::TypedRecord, h::UInt) = hash(r.identifier, hash(r.sequence, hash(r.quality, h)))
Base.:(==)(r1::TypedRecord, r2::TypedRecord) = hash(r1) == hash(r2)

@inline Base.length(record::TypedRecord) = length(record.sequence)

import FASTX: identifier, sequence, quality

@inline identifier(record::TypedRecord) = record.identifier

@inline sequence(record::TypedRecord) = record.sequence
@inline sequence(::Type{T}, record::TypedRecord) where T = T(record.sequence)

@inline quality(record::TypedRecord) = record.quality
@inline has_quality(record::TypedRecord) = record.quality isa QualityScores
@inline quality_values(record::TypedRecord) = has_quality(record) ? record.quality.values : nothing

"""
    error_prob_generator(record::TypedRecord)

Creates a generator of error probabilities for each character in the sequence.
"""
error_prob_generator(record::TypedRecord) = has_quality(record) ? error_prob_generator(record.quality) : nothing

"""
    error_probs(record::TypedRecord)

Creates a vector of error probabilities for each character in the sequence.
"""
error_probs(record::TypedRecord) = has_quality(record) ? error_probs(record.quality) : nothing

function Base.summary(record::TypedRecord)
    "$(TypedRecord{first(typeof(record).parameters)})"
end

function Base.show(io::IO, record::TypedRecord)
    print(io, "$(summary(record)):")
    print(io, "\n Identifier: $(identifier(record))")
    print(io, "\n   Sequence: ", sequence(record))
    if has_quality(record)
    print(io, "\n    Quality: ", quality(record))
    end
end