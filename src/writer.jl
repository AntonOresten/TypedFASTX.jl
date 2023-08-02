"""
    AbstractWriter{T}

Abstract type for typed FASTX writers. `T` is the type of the sequence in the records.
"""
abstract type AbstractWriter{T} end

"""
    StringWriter

Alias for `AbstractWriter{String}`. Can be used for constructing TypedFASTAWriter{String} and TypedFASTQWriter{String} instances.
"""
const StringWriter = AbstractWriter{String}

"""
    DNAWriter

Alias for `AbstractWriter{LongDNA{4}}`. Can be used for constructing TypedFASTAWriter{LongDNA{4}} and TypedFASTQWriter{LongDNA{4}} instances.
"""
const DNAWriter = AbstractWriter{LongDNA{4}}

"""
    RNAWriter

Alias for `AbstractWriter{LongRNA{4}}`. Can be used for constructing TypedFASTAWriter{LongRNA{4}} and TypedFASTQWriter{LongRNA{4}} instances.
"""
const RNAWriter = AbstractWriter{LongRNA{4}}

"""
    AAWriter

Alias for `AbstractWriter{LongAA}`. Can be used for constructing TypedFASTAWriter{LongAA} and TypedFASTQWriter{LongAA} instances.
"""
const AAWriter = AbstractWriter{LongAA}

"Constructor for AbstractWriter{T} that looks at the file extension of the given path."
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

function Base.close(f::Function, writer::AbstractWriter)
    try
        f(writer)
    finally
        close(writer)
    end
end

function Base.close(f::Function, W::Type{<:AbstractWriter}, path::String)
    writer = W(path)
    try
        f(writer)
    finally
        close(writer)
    end
end