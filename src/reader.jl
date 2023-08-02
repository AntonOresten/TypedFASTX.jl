"""
    AbstractReader{T}

Abstract type for typed FASTX readers. `T` is the type of the sequence in the records.
"""
abstract type AbstractReader{T} end

"""
    StringReader

Alias for `AbstractReader{String}`. Can be used for constructing TypedFASTAReader{String} and TypedFASTQReader{String} instances.
"""
const StringReader = AbstractReader{String}
    
"""
    DNAReader

Alias for `AbstractReader{LongDNA{4}}`. Can be used for constructing TypedFASTAReader{LongDNA{4}} and TypedFASTQReader{LongDNA{4}} instances.
"""
const DNAReader = AbstractReader{LongDNA{4}}

"""
    RNAReader

Alias for `AbstractReader{LongRNA{4}}`. Can be used for constructing TypedFASTAReader{LongRNA{4}} and TypedFASTQReader{LongRNA{4}} instances.
"""
const RNAReader = AbstractReader{LongRNA{4}}

"""
    AAReader

Alias for `AbstractReader{LongAA}`. Can be used for constructing TypedFASTAReader{LongAA} and TypedFASTQReader{LongAA} instances.
"""
const AAReader = AbstractReader{LongAA}

"Constructor for AbstractReader{T} that looks at the file extension of the given path."
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

function Base.open(f::Function, reader::AbstractReader)
    try
        f(reader)
    finally
        close(reader)
    end
end

function Base.open(f::Function, R::Type{<:AbstractReader}, path::String)
    reader = R(path)
    try
        f(reader)
    finally
        close(reader)
    end
end