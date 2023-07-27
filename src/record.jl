const EMPTY_NAME = ""

"""
    TypedRecord{T}

A type to represent a generic biological sequence record. 

### Fields
- `description::String`: The unique description for the sequence.
- `sequence::T`: The sequence itself. It can be of any type, including: `String`, `LongDNA{4}`, `LongRNA{4}` or `LongAA`.
- `quality::AbstractQuality`: The quality scores associated with the sequence. `Nothing` indicates absence of quality scores.
"""
struct TypedRecord{T, Q <: AbstractQuality}
    description::String
    sequence::T
    quality::Q

    # DNARecord{NoQuality}("Ricky", dna"ACGT")
    function TypedRecord{T, NoQuality}(name::AbstractString, seq::T) where T
        new{T, NoQuality}(name, seq, NO_QUALITY)
    end

    # DNARecord{NoQuality}("Ricky", "ACGT")
    function TypedRecord{T, NoQuality}(name::AbstractString, seq::Any) where T
        TypedRecord{T, NoQuality}(name, T(seq))
    end

    # DNARecord("Ricky", dna"ACGT")
    function TypedRecord{T}(name::AbstractString, seq::T) where T
        TypedRecord{T, NoQuality}(name, seq)
    end

    # DNARecord("Ricky", "ACGT")
    function TypedRecord{T}(name::AbstractString, seq::Any) where T
        TypedRecord{T, NoQuality}(name, T(seq))
    end

    # TypedRecord("Ricky", dna"ACGT")
    function TypedRecord(name::AbstractString, seq::T) where T
        TypedRecord{T, NoQuality}(name, seq)
    end


    # DNARecord{QualityScores}("Ricky", dna"ACGT", QualityScores("!!!!"))
    function TypedRecord{T, QualityScores}(name::AbstractString, seq::T, qual::QualityScores) where T
        seq_len, qual_len = length(seq), length(qual)
        @assert seq_len == qual_len "$(TypedRecord{T}) \"$name\": sequence length ($seq_len) does not match quality length ($qual_len)."
        new{T, QualityScores}(name, seq, qual)
    end

    # DNARecord{QualityScores}("Ricky", dna"ACGT", NO_QUALITY)
    function TypedRecord{T, QualityScores}(name::AbstractString, seq::T, qual::NoQuality) where T
        new{T, NoQuality}(name, seq, qual)
    end

    # DNARecord{QualityScores}("Ricky", "ACGT", "!!!!")
    function TypedRecord{T, QualityScores}(name::AbstractString, seq::Any, qual::Any) where T
        TypedRecord{T, QualityScores}(name, T(seq), QualityScores(qual))
    end

    # DNARecord("Ricky", dna"ACGT", "!!!!")
    function TypedRecord{T}(name::AbstractString, seq::T, qual::Any) where T
        TypedRecord{T, QualityScores}(name, seq, QualityScores(qual))
    end

    # DNARecord("Ricky", "ACGT", "!!!!")
    function TypedRecord{T}(name::AbstractString, seq::Any, qual::Any) where T
        TypedRecord{T, QualityScores}(name, T(seq), QualityScores(qual))
    end

    # TypedRecord("Ricky", dna"ACGT", "!!!!")
    function TypedRecord(name::AbstractString, seq::T, qual::Any) where T
        TypedRecord{T, QualityScores}(name, seq, QualityScores(qual))
    end


    # DNARecord{NoQuality}(RNARecord("Ricky", "ACGU"))
    function TypedRecord{T, NoQuality}(record::TypedRecord{<:Any, NoQuality}) where T
        TypedRecord{T, NoQuality}(record.description, record.sequence)
    end
    
    # DNARecord{NoQuality}(RNARecord("Ricky", "ACGU", "!!!!"))
    function TypedRecord{T, NoQuality}(record::TypedRecord{<:Any, QualityScores}) where T
        TypedRecord{T, NoQuality}(record.description, record.sequence)
    end

    # DNARecord(RNARecord("Ricky", "ACGU"))
    function TypedRecord{T}(record::TypedRecord{<:Any, NoQuality}) where T
        TypedRecord{T, NoQuality}(record.description, record.sequence)
    end
    
    # DNARecord{QualityScores}(RNARecord("Ricky", "ACGU", "!!!!"))
    function TypedRecord{T, QualityScores}(record::TypedRecord{<:Any, QualityScores}) where T
        TypedRecord{T, QualityScores}(record.description, record.sequence, record.quality)
    end

    # DNARecord(RNARecord("Ricky", "ACGU", "!!!!"))
    function TypedRecord{T}(record::TypedRecord{<:Any, QualityScores}) where T
        TypedRecord{T, QualityScores}(record.description, record.sequence, record.quality)
    end

    # TypedRecord(DNARecord("Ricky", "ACGT", "!!!!"))
    function TypedRecord(record::TypedRecord{T, Q}) where {T, Q}
        new{T, Q}(record.description, record.sequence, record.quality)
    end

    # DNARecord("ACGT")
    function TypedRecord{T}(seq::Any) where T
        TypedRecord{T, NoQuality}(EMPTY_NAME, seq)
    end

    # DNARecord(rna"ACGU", QualityScores("!!!!"))
    # DNARecord(rna"ACGU", "!!!!")
    function TypedRecord{T}(seq::Any, qual::Any) where T
        TypedRecord{T, QualityScores}(EMPTY_NAME, T(seq), qual)
    end

    # needed to avoid ambiguity with DNARecord(name::AbstractString, seq::Any)
    # DNARecord("ACGT", QualityScores("!!!!"))
    function TypedRecord{T}(seq::AbstractString, qual::QualityScores) where T
        TypedRecord{T, QualityScores}(EMPTY_NAME, T(seq), qual)
    end

    # TypedRecord(dna"ACGT")
    function TypedRecord(seq::T) where T
        TypedRecord{T, NoQuality}(EMPTY_NAME, seq)
    end

    # TypedRecord(dna"ACGT", QualityScores("!!!!"))
    function TypedRecord(seq::T, qual::QualityScores) where T
        TypedRecord{T, QualityScores}(EMPTY_NAME, seq, qual)
    end

    # TypedRecord(dna"ACGT", "!!!!")
    function TypedRecord(seq::T, qual::Any) where T
        TypedRecord{T, QualityScores}(EMPTY_NAME, seq, qual)
    end
end

const StringRecord = TypedRecord{String}
const DNARecord = TypedRecord{LongDNA{4}}
const RNARecord = TypedRecord{LongRNA{4}}
const AARecord = TypedRecord{LongAA}

Base.hash(r::TypedRecord, h::UInt) = hash(r.description, hash(r.sequence, hash(r.quality, h)))
Base.:(==)(r1::TypedRecord, r2::TypedRecord) = r1.description == r2.description && r1.sequence == r2.sequence && r1.quality == r2.quality
Base.isless(r1::TypedRecord, r2::TypedRecord) = isless(r1.sequence, r2.sequence)

@inline Base.length(record::TypedRecord) = length(record.sequence)

import FASTX: description, identifier, sequence, quality

@inline description(record::TypedRecord) = record.description
@inline identifier(record::TypedRecord) = first(split(record.description, ' '))

@inline sequence(record::TypedRecord) = record.sequence
@inline sequence(::Type{T}, record::TypedRecord{T}) where T = record.sequence
@inline sequence(::Type{T}, record::TypedRecord) where T = T(record.sequence)

@inline quality(record::TypedRecord) = record.quality
@inline has_quality(record::TypedRecord) = record.quality isa QualityScores
@inline quality_values(record::TypedRecord) = has_quality(record) ? record.quality.values : nothing

function BioSequences.reverse_complement(record::TypedRecord{T, NoQuality}) where T <: Union{LongDNA, LongRNA}
    TypedRecord{T}(description(record), reverse_complement(sequence(record)))
end

function BioSequences.reverse_complement(record::TypedRecord{T, QualityScores}) where T <: Union{LongDNA, LongRNA}
    TypedRecord{T}(description(record), reverse_complement(record.sequence), reverse(record.quality))
end

function BioSequences.reverse_complement!(record::TypedRecord{T, NoQuality}) where T <: Union{LongDNA, LongRNA}
    reverse_complement!(record.sequence)
    record
end

function BioSequences.reverse_complement!(record::TypedRecord{T, QualityScores}) where T <: Union{LongDNA, LongRNA}
    reverse_complement!(record.sequence)
    reverse!(record.quality)
    record
end

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
    print(io, ">$(description(record))\n$(sequence(record))")
end

function Base.print(io::IO, record::TypedRecord{T, QualityScores}) where T
    print(io, "@$(description(record))\n$(sequence(record))\n+\n$(quality(record))")
end

function Base.show(io::IO, record::TypedRecord{T, NoQuality}) where T
    print(io,
        summary(record), '(',
        repr(description(record)),
        ", ", repr(FASTX.truncate(String(sequence(record)), 20)),
        ')'
    )
end

function Base.show(io::IO, record::TypedRecord{T, QualityScores}) where T
    print(io,
        summary(record), '(',
        repr(description(record)),
        ", ", repr(FASTX.truncate(String(sequence(record)), 20)),
        ", ", repr(FASTX.truncate(String(quality(record)), 20)),
        ')'
    )
end

function Base.show(io::IO, ::MIME"text/plain", record::TypedRecord{T, NoQuality}) where T
    print(io, "$(summary(record)):")
    print(io, "\n description: ", isempty(description(record)) ? "<empty>" : repr(description(record)))
    print(io, "\n   sequence: ", repr(FASTX.truncate(String(sequence(record)), 40)))
end

function Base.show(io::IO, ::MIME"text/plain", record::TypedRecord{T, QualityScores}) where T
    print(io, "$(summary(record)):")
    print(io, "\n description: ", isempty(description(record)) ? "<empty>" : repr(description(record)))
    print(io, "\n   sequence: ", repr(FASTX.truncate(String(sequence(record)), 40)))
    print(io, "\n    quality: ", repr(FASTX.truncate(String(quality(record)), 40)))
end