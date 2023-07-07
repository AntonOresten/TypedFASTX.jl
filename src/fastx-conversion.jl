# Methods for converting between TypedRecord and FASTX records

function TypedRecord{T}(fasta_record::FASTARecord) where T
    id = identifier(fasta_record)
    seq = sequence(T, fasta_record)
    TypedRecord{T}(id, seq)
end

function TypedRecord{T}(fastq_record::FASTQRecord; qualformat::Symbol = :sanger, keep_qual::Bool = true) where T
    id = identifier(fastq_record)
    seq = sequence(T, fastq_record)
    qual = keep_qual ? collect(quality_scores(fastq_record, qualformat)) : nothing
    TypedRecord{T}(id, seq, qual)
end


function FASTA.Record(record::TypedRecord)
    # Ignore the "Possible method call error." -- everything is fine.
    FASTA.Record(record.identifier, record.sequence)
end

function FASTQ.Record(record::TypedRecord)
    if !has_quality(record)
        error("Can't convert a `TypedRecord` without quality to a `FASTX.FASTQ.Record`.")
    end
    FASTQ.Record(record.identifier, record.sequence, record.quality.values, offset=record.quality.encoding.offset)
end

