# Methods for converting between TypedRecord and FASTX records

#====--- FASTX to TypedFASTX ---====#

function Base.convert(::Type{TypedFASTA.Record{T}}, record::Union{FASTX.FASTA.Record, FASTX.FASTQ.Record}) where T
    TypedFASTA.Record{T}(
        description(record),
        sequence(T, record))
end

function Base.convert(::Type{AbstractRecord{T}}, fasta_record::FASTX.FASTA.Record) where T
    Base.convert(TypedFASTA.Record{T}, fasta_record)
end


function Base.convert(::Type{TypedFASTQ.Record{T}}, fastq_record::FASTX.FASTQ.Record, encoding::FASTX.FASTQ.QualityEncoding = FASTX.FASTQ.SANGER_QUAL_ENCODING) where T
    TypedFASTQ.Record{T}(
        description(fastq_record),
        sequence(T, fastq_record),
        collect(FASTX.quality_scores(fastq_record, encoding)))
end

function Base.convert(::Type{TypedFASTQ.Record{T}}, ::FASTX.FASTA.Record, ::FASTX.FASTQ.QualityEncoding = FASTX.FASTQ.SANGER_QUAL_ENCODING) where T
    error("Can't convert a `FASTX.FASTA.Record` to a `$(TypedFASTQ.Record{T})` with quality.")
end

function Base.convert(::Type{AbstractRecord{T}}, fastq_record::FASTX.FASTQ.Record) where T
    Base.convert(TypedFASTQ.Record{T}, fastq_record)
end

#==--- TypedFASTX to FASTX ---==#

function Base.convert(::Type{FASTX.FASTA.Record}, record::AbstractRecord{T}) where T
    FASTX.FASTA.Record(
        description(record),
        sequence(String, record))
end

function Base.convert(::Type{FASTX.FASTQ.Record}, record::TypedFASTQ.Record{T}) where T
    FASTX.FASTQ.Record(
        description(record),
        sequence(String, record),
        quality_values(record),
        offset=record.quality.encoding.offset)
end

function Base.convert(::Type{FASTX.FASTQ.Record}, ::TypedFASTA.Record{T}) where T
    error("Can't convert a `$(TypedFASTA.Record{T})` with no quality to a `FASTX.FASTQ.Record`.")
end


#==--- Writing ---==#

Base.write(w::TypedFASTA.Writer{T}, record::TypedFASTQ.Record{T}) where T = write(w, convert(TypedFASTA.Record, record))
Base.write(::TypedFASTQ.Writer{T}, ::TypedFASTA.Record{T}) where T = error("Can't write a FASTA record to a FASTQ file.")