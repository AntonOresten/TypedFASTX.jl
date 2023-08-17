const EMPTY_DESCRIPTION = ""

"""
    TypedFASTA.Record{T}

A typed FASTA record. `T` is the type of the sequence.
"""
struct Record{T} <: TypedRecord{T}
    description::String
    sequence::T

    # TypedFASTA.Record("Ricky", dna"ACGT")
    function Record{T}(description::String, sequence::T) where T
        new{T}(description, sequence)
    end

    function TypedRecord{T}(sequence::Any) where T
        new{T}(EMPTY_DESCRIPTION, T(sequence))
    end

    # TypedFASTA.Record{LongDNA{4}}("Ricky", dna"ACGT")
    # TypedFASTA.Record{LongDNA{4}}("Ricky", "ACGT")
    function Record{T}(description::AbstractString, sequence::Any) where T
        new{T}(description, T(sequence))
    end

    # TypedRecord{LongDNA{4}}("Ricky", "ACGT")
    # DNARecord("Ricky", "ACGT")
    function TypedRecord{T}(description::AbstractString, sequence::Any) where T
        Record{T}(description, T(sequence))
    end
end

# TypedFASTQ.Record -> TypedFASTA.Record
function Base.convert(::Type{Record{T}}, record::TypedRecord{T}) where T
    Record{T}(description(record), sequence(record))
end

# FASTX.Record -> TypedFASTA.Record
function Base.convert(::Type{Record{T}}, record::FASTX.Record) where T
    Record{T}(
        description(record),
        sequence(String, record))
end

Base.hash(r::Record, h::UInt) = hash(r.description, hash(r.sequence, h))
Base.:(==)(r1::Record{T}, r2::Record{T}) where T = r1.description == r2.description && r1.sequence == r2.sequence
Base.getindex(record::Record{T}, r::UnitRange{<:Integer}) where T = Record{T}(description(record), sequence(record)[r])

function BioSequences.reverse_complement(record::Record{T}) where T <: Union{LongDNA, LongRNA}
    Record{T}(description(record), reverse_complement(sequence(record)))
end

function BioSequences.reverse_complement!(record::Record{T}) where T <: Union{LongDNA, LongRNA}
    reverse_complement!(record.sequence)
    record
end

function Base.show(io::IO, record::Record{T}) where T
    print(io,
        summary(record), '(',
        repr(description(record)),
        ", ", repr(FASTX.truncate(String(sequence(record)), 20)),
        ')'
    )
end

function Base.show(io::IO, ::MIME"text/plain", record::Record{T}) where T
    print(io, summary(record), " (FASTA):")
    print(io, "\n description: ", isempty(description(record)) ? "<empty>" : repr(description(record)))
    print(io, "\n    sequence: ", repr(FASTX.truncate(String(sequence(record)), 40)))
end

function Base.print(io::IO, record::Record{T}) where T
    print(io, ">$(description(record))\n$(sequence(record))\n")
end