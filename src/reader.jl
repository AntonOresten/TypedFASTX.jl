abstract type AbstractReader{T} end

const StringReader = AbstractReader{String}
const DNAReader = AbstractReader{LongDNA{4}}
const RNAReader = AbstractReader{LongRNA{4}}
const AAReader = AbstractReader{LongAA}

function AbstractReader{T}(path::String) where T
    _, ext = splitext(path)
    ext = lowercase(ext)
    if ext in [".fasta", "fa"]
        return TypedFASTAReader{T}(path)
    elseif ext in [".fastq", ".fq"]
        return TypedFASTQReader{T}(path)
    else
        error("Unknown file extension $ext")
    end
end

Base.close(r::AbstractReader) = close(r.reader)