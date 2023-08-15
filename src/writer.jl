"""
    TypedWriter{T}

Abstract type for typed FASTX writers. `T` is the type of the sequence in the records.
"""
abstract type TypedWriter{T} end

"""
    StringWriter

Alias for `TypedWriter{String}`. Can be used for constructing TypedFASTAWriter{String} and TypedFASTQWriter{String} instances.
"""
const StringWriter = TypedWriter{String}

"""
    DNAWriter

Alias for `TypedWriter{LongDNA{4}}`. Can be used for constructing TypedFASTAWriter{LongDNA{4}} and TypedFASTQWriter{LongDNA{4}} instances.
"""
const DNAWriter = TypedWriter{LongDNA{4}}

"""
    RNAWriter

Alias for `TypedWriter{LongRNA{4}}`. Can be used for constructing TypedFASTAWriter{LongRNA{4}} and TypedFASTQWriter{LongRNA{4}} instances.
"""
const RNAWriter = TypedWriter{LongRNA{4}}

"""
    AAWriter

Alias for `TypedWriter{LongAA}`. Can be used for constructing TypedFASTAWriter{LongAA} and TypedFASTQWriter{LongAA} instances.
"""
const AAWriter = TypedWriter{LongAA}

function Base.summary(::TypedWriter{T}) where T
    string(TypedWriter{T})
end

"""
Constructor for TypedWriter{T} that looks at the file extension of the given path
to decide writer type."""
function TypedWriter{T}(path::String; append::Bool=false) where T
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

Base.close(w::TypedWriter) = close(w.io)

function Base.open(f::Function, writer::TypedWriter)
    try
        f(writer)
    finally
        close(writer)
    end
end

function Base.open(f::Function, W::Type{<:TypedWriter}, path::String)
    writer = W(path)
    try
        f(writer)
    finally
        close(writer)
    end
end