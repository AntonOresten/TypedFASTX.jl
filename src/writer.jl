abstract type AbstractWriter{T} end

const StringWriter = AbstractWriter{String}
const DNAWriter = AbstractWriter{LongDNA{4}}
const RNAWriter = AbstractWriter{LongRNA{4}}
const AAWriter = AbstractWriter{LongAA}

function AbstractWriter{T}(path::String; append::Bool=false) where T
    _, ext = splitext(path)
    ext = lowercase(ext)
    if ext in [".fasta", "fa"]
        return TypedFASTAWriter{T}(path, append=append)
    elseif ext in [".fastq", ".fq"]
        return TypedFASTQWriter{T}(path, append=append)
    else
        error("Unknown file extension $ext")
    end
end

Base.close(w::AbstractWriter) = close(w.io)