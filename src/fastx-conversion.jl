# Methods for converting between TypedRecord and FASTX records
const FASTXRecord = Union{FASTARecord, FASTQRecord}

function TypedRecord{T, NoQuality}(fasta_record::FASTARecord) where T
    id = identifier(fasta_record)
    seq = sequence(T, fasta_record)
    TypedRecord{T}(id, seq)
end

function TypedRecord{T, QualityScores}(::FASTARecord) where T
    error("Can't convert a `FASTX.FASTA.Record` to a `$(TypedRecord{T})` with quality.")
end

function TypedRecord{T}(fasta_record::FASTARecord) where T
    TypedRecord{T, NoQuality}(fasta_record)
end


function TypedRecord{T, NoQuality}(fastq_record::FASTQRecord) where T
    id = identifier(fastq_record)
    seq = sequence(T, fastq_record)
    TypedRecord{T}(id, seq)
end

function TypedRecord{T, QualityScores}(fastq_record::FASTQRecord, encoding::QualityEncoding = FASTQ.SANGER_QUAL_ENCODING) where T
    id = identifier(fastq_record)
    seq = sequence(T, fastq_record)
    qual = collect(quality_scores(fastq_record, encoding))
    TypedRecord{T}(id, seq, qual)
end

function TypedRecord{T, QualityScores}(fastq_record::FASTQRecord, encoding_name::Symbol) where T
    encoding = encoding_name_to_quality_encoding(encoding_name)
    id = identifier(fastq_record)
    seq = sequence(T, fastq_record)
    qual = collect(quality_scores(fastq_record, encoding))
    TypedRecord{T}(id, seq, qual)
end

function TypedRecord{T}(fastq_record::FASTQRecord) where T
    TypedRecord{T, QualityScores}(fastq_record)
end

function Base.convert(::Type{TypedRecord{T}}, record::FASTARecord) where T
    TypedRecord{T, NoQuality}(record)
end

function Base.convert(::Type{TypedRecord{T}}, record::FASTQRecord) where T
    TypedRecord{T, QualityScores}(record)
end


function FASTA.Record(record::TypedRecord{T}) where T
    # Ignore the "Possible method call error." -- everything is fine.
    FASTA.Record(identifier(record), sequence(record))
end


function FASTQ.Record(::TypedRecord{T, NoQuality}) where T
    error("Can't convert a `$(TypedRecord{T})` with no quality to a `FASTX.FASTQ.Record`.")
end

function FASTQ.Record(record::TypedRecord{T, QualityScores}) where T
    FASTQ.Record(identifier(record), sequence(record), quality_values(record), offset=record.quality.encoding.offset)
end

function Base.convert(::Type{FASTXRecord}, record::TypedRecord)
    if record.quality isa NoQuality
        FASTA.Record(record)
    else
        FASTQ.Record(record)
    end
end