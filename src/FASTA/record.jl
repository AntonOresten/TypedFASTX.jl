struct Record{T} <: AbstractRecord{T}
    description::String
    sequence::T

    # TypedFASTA.Record{LongDNA{4}}("Ricky", "ACGT")
    function Record{T}(name::AbstractString, sequence::Any) where T
        new{T}(name, T(sequence))
    end

    # AbstractRecord{LongDNA{4}}("Ricky", "ACGT")
    # DNARecord("Ricky", "ACGT")
    function AbstractRecord{T}(name::AbstractString, sequence::Any) where T
        Record{T}(name, sequence)
    end
end

function Base.convert(::Type{Record{T}}, record::Union{FASTX.FASTA.Record, FASTX.FASTQ.Record}) where T
    Record{T}(
        description(record),
        sequence(T, record))
end

function Base.convert(::Type{AbstractRecord{T}}, fasta_record::FASTX.FASTA.Record) where T
    convert(Record{T}, fasta_record)
end

function Base.convert(::Type{FASTX.FASTA.Record}, record::AbstractRecord{T}) where T
    FASTX.FASTA.Record(
        description(record),
        sequence(String, record))
end

function Base.convert(::Type{FASTX.FASTQ.Record}, ::Record{T}) where T
    error("Can't convert a `$(Record{T})` with no quality to a `FASTX.FASTQ.Record`.")
end


const StringRecord = Record{String}
const DNARecord = Record{LongDNA{4}}
const RNARecord = Record{LongRNA{4}}
const AARecord = Record{LongAA}

Base.hash(r::Record, h::UInt) = hash(r.description, hash(r.sequence, h))
Base.:(==)(r1::Record{T}, r2::Record{T}) where T = r1.description == r2.description && r1.sequence == r2.sequence

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
    print(io, "$(summary(record)):")
    print(io, "\n description: ", isempty(description(record)) ? "<empty>" : repr(description(record)))
    print(io, "\n    sequence: ", repr(FASTX.truncate(String(sequence(record)), 40)))
end

function Base.print(io::IO, record::Record{T}) where T
    print(io, ">$(description(record))\n$(sequence(record))\n")
end