struct Record{T} <: AbstractRecord{T}
    description::String
    sequence::T
    quality::QualityScores

    function Record{T}(name::AbstractString, sequence::Any, quality::Any) where T
        qs = QualityScores(quality)
        seq_len, qs_len = length(sequence), length(qs)
        @assert seq_len == qs_len "$(Record{T}) \"$name\": sequence length ($seq_len) does not match quality length ($qs_len)."
        new{T}(name, T(sequence), qs)
    end

    function AbstractRecord{T}(name::AbstractString, sequence::Any, quality::Any) where T
        Record{T}(name, sequence, quality)
    end
end

const StringRecord = Record{String}
const DNARecord = Record{LongDNA{4}}
const RNARecord = Record{LongRNA{4}}
const AARecord = Record{LongAA}

Base.hash(r::Record, h::UInt) = hash(r.description, hash(r.sequence, hash(r.quality, h)))
Base.:(==)(r1::Record{T}, r2::Record{T}) where T = r1.description == r2.description && r1.sequence == r2.sequence && r1.quality == r2.quality

import FASTX: quality

@inline quality(record::Record) = record.quality
@inline quality_values(record::Record) = record.quality.values

function BioSequences.reverse_complement(record::Record{T}) where T <: Union{LongDNA, LongRNA}
    Record{T}(description(record), reverse_complement(record.sequence), reverse(record.quality))
end

function BioSequences.reverse_complement!(record::Record{T}) where T <: Union{LongDNA, LongRNA}
    reverse_complement!(record.sequence)
    reverse!(record.quality)
    record
end

function Base.show(io::IO, record::Record{T}) where T
    print(io,
        summary(record), '(',
        repr(description(record)),
        ", ", repr(FASTX.truncate(String(sequence(record)), 20)),
        ", ", repr(FASTX.truncate(String(quality(record)), 20)),
        ')'
    )
end

function Base.show(io::IO, ::MIME"text/plain", record::Record{T}) where T
    print(io, "$(summary(record)):")
    print(io, "\n description: ", isempty(description(record)) ? "<empty>" : repr(description(record)))
    print(io, "\n    sequence: ", repr(FASTX.truncate(String(sequence(record)), 40)))
    print(io, "\n     quality: ", repr(FASTX.truncate(String(quality(record)), 40)))
end

function Base.print(io::IO, record::Record{T}) where T
    print(io, "@$(description(record))\n$(sequence(record))\n+\n$(quality(record))\n")
end

"""
    error_prob_generator(record::Record)

Creates a generator of error probabilities for each character in the sequence.
"""
error_prob_generator(record::Record) = error_prob_generator(record.quality)

"""
    error_probs(record::Record)

Creates a vector of error probabilities for each character in the sequence.
"""
error_probs(record::Record) = error_probs(record.quality)

"""
    error_rate(record::Record)

Calculates the error rate of the record.
"""
error_rate(record::Record) = error_rate(record.quality)
