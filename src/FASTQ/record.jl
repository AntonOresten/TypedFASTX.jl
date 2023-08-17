"""
    TypedFASTQ.Record{T}

A FASTQ record with a typed sequence and quality scores.
"""
struct Record{T} <: TypedRecord{T}
    description::String
    sequence::T
    quality::QualityScores

    function Record{T}(description::AbstractString, sequence::T, qs::QualityScores) where T
        seq_len, qs_len = length(sequence), length(qs)
        @assert seq_len == qs_len "$(Record{T}) \"$description\": sequence length ($seq_len) does not match quality length ($qs_len)."
        new{T}(description, T(sequence), qs)
    end

    function Record{T}(description::AbstractString, sequence::Any, quality::Any) where T
        Record{T}(description, T(sequence), QualityScores(quality))
    end

    function TypedRecord{T}(description::AbstractString, sequence::Any, quality::Any) where T
        Record{T}(description, sequence, quality)
    end
end

function Base.convert(::Type{Record{T}}, fastq_record::FASTX.FASTQ.Record, encoding::FASTX.FASTQ.QualityEncoding = FASTX.FASTQ.SANGER_QUAL_ENCODING) where T
    Record{T}(
        description(fastq_record),
        sequence(T, fastq_record),
        collect(FASTX.quality_scores(fastq_record, encoding)))
end

function Base.convert(::Type{FASTX.FASTQ.Record}, record::Record{T}) where T
    FASTX.FASTQ.Record(
        description(record),
        sequence(String, record),
        quality_values(record),
        offset=record.quality.encoding.offset)
end

Base.hash(r::Record, h::UInt) = hash(r.description, hash(r.sequence, hash(r.quality, h)))
Base.:(==)(r1::Record{T}, r2::Record{T}) where T = r1.description == r2.description && r1.sequence == r2.sequence && r1.quality == r2.quality
Base.getindex(record::Record{T}, r::UnitRange{<:Integer}) where T = Record{T}(description(record), sequence(record)[r], quality(record)[r])

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
    print(io, summary(record), " (FASTQ):")
    print(io, "\n description: ", isempty(description(record)) ? "<empty>" : repr(description(record)))
    print(io, "\n    sequence: ", repr(FASTX.truncate(String(sequence(record)), 40)))
    print(io, "\n     quality: ", repr(FASTX.truncate(String(quality(record)), 40)))
end

function Base.print(io::IO, record::Record{T}) where T
    print(io, "@$(description(record))\n$(sequence(record))\n+\n$(quality(record))\n")
end