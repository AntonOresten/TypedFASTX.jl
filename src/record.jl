const EMPTY_ID = ""

"""
    TypedRecord{T}

A type to represent a generic biological sequence record. 

### Fields
- `identifier::String`: The unique identifier for the sequence.
- `sequence::T`: The sequence itself. It can be of any type, including: `String`, `LongDNA{4}`, `LongRNA{4}` or `LongAA`.
- `quality::Union{NoQuality, QualityScores}`: The quality scores associated with the sequence. `Nothing` indicates absence of quality scores.
"""
struct TypedRecord{T, Q <: AbstractQuality}
    identifier::String
    sequence::T
    quality::Q

    # DNARecord{NoQuality}("Ricky", dna"ACGT")
    function TypedRecord{T, NoQuality}(id::AbstractString, seq::T) where T
        new{T, NoQuality}(id, seq, NO_QUALITY)
    end

    # DNARecord{NoQuality}("Ricky", "ACGT")
    function TypedRecord{T, NoQuality}(id::AbstractString, seq::Any) where T
        TypedRecord{T, NoQuality}(id, T(seq))
    end

    # DNARecord("Ricky", "ACGT")
    function TypedRecord{T}(id::AbstractString, seq::Any) where T
        TypedRecord{T, NoQuality}(id, T(seq))
    end

    # TypedRecord("Ricky", dna"ACGT")
    function TypedRecord(id::AbstractString, seq::T) where T
        TypedRecord{T, NoQuality}(id, seq)
    end

    # DNARecord{NoQuality}("ACGT")
    function TypedRecord{T, NoQuality}(seq::Any) where T
        TypedRecord{T, NoQuality}(EMPTY_ID, T(seq))
    end

    # DNARecord("ACGT")
    function TypedRecord{T}(seq::Any) where T
        TypedRecord{T, NoQuality}(EMPTY_ID, T(seq))
    end

    # TypedRecord(dna"ACGT")
    function TypedRecord(seq::T) where T
        TypedRecord{T, NoQuality}(EMPTY_ID, seq)
    end


    # DNARecord{QualityScores}("Ricky", dna"ACGT", QualityScores("!!!!"))
    function TypedRecord{T, QualityScores}(id::AbstractString, seq::T, qs::QualityScores) where T
        seq_len, qs_len = length(seq), length(qs)
        @assert seq_len == qs_len "$(TypedRecord{T}) \"$id\": sequence length ($seq_len) does not match quality length ($qs_len)."
        new{T, QualityScores}(id, seq, qs)
    end

    # DNARecord{QualityScores}("Ricky", "ACGT", "!!!!")
    function TypedRecord{T, QualityScores}(id::AbstractString, seq::Any, qual::Any) where T
        TypedRecord{T, QualityScores}(id, T(seq), QualityScores(qual))
    end

    # DNARecord("Ricky", "ACGT", "!!!!")
    function TypedRecord{T}(id::AbstractString, seq::Any, qual::Any) where T
        TypedRecord{T, QualityScores}(id, T(seq), QualityScores(qual))
    end

    # TypedRecord("Ricky", dna"ACGT", "!!!!")
    function TypedRecord(id::AbstractString, seq::T, qual::Any) where T
        TypedRecord{T, QualityScores}(id, seq, QualityScores(qual))
    end


    # DNARecord("ACGT", QualityScores("!!!!"))
    function TypedRecord{T}(seq::AbstractString, qs::QualityScores) where T
        TypedRecord{T, QualityScores}(EMPTY_ID, T(seq), qs)
    end

    # DNARecord{QualityScores}("ACGT", "!!!!")
    function TypedRecord{T, QualityScores}(seq::Any, qual::Any) where T
        TypedRecord{T, QualityScores}(EMPTY_ID, T(seq), QualityScores(qual))
    end

    # not DNARecord("ACGT", "!!!!")
    # DNARecord(rna"ACGT", "!!!!")
    # DNARecord(dna"ACGT", "!!!!")
    function TypedRecord{T}(seq::Any, qual::Any) where T
        TypedRecord{T, QualityScores}(EMPTY_ID, T(seq), QualityScores(qual))
    end

    # TypedRecord(dna"ACGT", "!!!!")
    function TypedRecord(seq::T, qual::Any) where T
        TypedRecord{T, QualityScores}(EMPTY_ID, seq, QualityScores(qual))
    end


    # DNARecord{NoQuality}(RNARecord("Ricky", "ACGU"))
    function TypedRecord{T, NoQuality}(record::TypedRecord{<:Any, NoQuality}) where T
        TypedRecord{T, NoQuality}(record.identifier, record.sequence)
    end
    
    # DNARecord{NoQuality}(RNARecord("Ricky", "ACGU", "!!!!"))
    function TypedRecord{T, NoQuality}(record::TypedRecord{<:Any, QualityScores}) where T
        TypedRecord{T, NoQuality}(record.identifier, record.sequence)
    end

    # DNARecord(RNARecord("Ricky", "ACGU"))
    function TypedRecord{T}(record::TypedRecord{<:Any, NoQuality}) where T
        TypedRecord{T, NoQuality}(record.identifier, record.sequence)
    end
    
    # DNARecord{QualityScores}(RNARecord("Ricky", "ACGU", "!!!!"))
    function TypedRecord{T, QualityScores}(record::TypedRecord{<:Any, QualityScores}) where T
        TypedRecord{T, QualityScores}(record.identifier, record.sequence, record.quality)
    end

    # DNARecord(RNARecord("Ricky", "ACGU", "!!!!"))
    function TypedRecord{T}(record::TypedRecord{<:Any, QualityScores}) where T
        TypedRecord{T, QualityScores}(record.identifier, record.sequence, record.quality)
    end

    # TypedRecord(DNARecord("Ricky", "ACGT", "!!!!"))
    function TypedRecord(record::TypedRecord{T, Q}) where {T, Q}
        new{T, Q}(record.identifier, record.sequence, record.quality)
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

function Base.summary(::TypedRecord{T}) where T
    "$(TypedRecord{T})"
end

function Base.print(io::IO, record::TypedRecord{T, NoQuality}) where T
    print(io, ">$(identifier(record))\n$(sequence(record))")
end

function Base.print(io::IO, record::TypedRecord{T, QualityScores}) where T
    print(io, "@$(identifier(record))\n$(sequence(record))\n+\n$(quality(record))")
end

function Base.show(io::IO, record::TypedRecord{T, NoQuality}) where T
    print(io,
        summary(record), '(',
        repr(identifier(record)),
        ", ", repr(FASTX.truncate(String(sequence(record)), 20)),
        ')'
    )
end

function Base.show(io::IO, record::TypedRecord{T, QualityScores}) where T
    print(io,
        summary(record), '(',
        repr(identifier(record)),
        ", ", repr(FASTX.truncate(String(sequence(record)), 20)),
        ", ", repr(FASTX.truncate(String(quality(record)), 20)),
        ')'
    )
end

function Base.show(io::IO, ::MIME"text/plain", record::TypedRecord{T, NoQuality}) where T
    print(io, "$(summary(record)):")
    print(io, "\n identifier: ", isempty(identifier(record)) ? "<empty>" : repr(identifier(record)))
    print(io, "\n   sequence: ", repr(FASTX.truncate(String(sequence(record)), 40)))
end

function Base.show(io::IO, ::MIME"text/plain", record::TypedRecord{T, QualityScores}) where T
    print(io, "$(summary(record)):")
    print(io, "\n identifier: ", isempty(identifier(record)) ? "<empty>" : repr(identifier(record)))
    print(io, "\n   sequence: ", repr(FASTX.truncate(String(sequence(record)), 40)))
    print(io, "\n    quality: ", repr(FASTX.truncate(String(quality(record)), 40)))
end