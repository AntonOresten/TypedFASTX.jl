"""
    TypedReader{T}

Abstract type for typed FASTX readers. `T` is the type of the sequence in the records.
"""
abstract type TypedReader{T} end

"""
    StringReader

Alias for `TypedReader{String}`. Can be used for constructing TypedFASTAReader{String} and TypedFASTQReader{String} instances.
"""
const StringReader = TypedReader{String}
    
"""
    DNAReader

Alias for `TypedReader{LongDNA{4}}`. Can be used for constructing TypedFASTAReader{LongDNA{4}} and TypedFASTQReader{LongDNA{4}} instances.
"""
const DNAReader = TypedReader{LongDNA{4}}

"""
    RNAReader

Alias for `TypedReader{LongRNA{4}}`. Can be used for constructing TypedFASTAReader{LongRNA{4}} and TypedFASTQReader{LongRNA{4}} instances.
"""
const RNAReader = TypedReader{LongRNA{4}}

"""
    AAReader

Alias for `TypedReader{LongAA}`. Can be used for constructing TypedFASTAReader{LongAA} and TypedFASTQReader{LongAA} instances.
"""
const AAReader = TypedReader{LongAA}

"Constructor for TypedReader{T} that looks at the file extension of the given path
to decide reader type."
function TypedReader{T}(path::String) where T
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

Base.close(r::TypedReader) = close(r.reader)

function Base.open(f::Function, reader::TypedReader)
    try
        f(reader)
    finally
        close(reader)
    end
end

function Base.open(f::Function, R::Type{<:TypedReader}, path::String)
    reader = R(path)
    try
        f(reader)
    finally
        close(reader)
    end
end

Base.collect(reader::TypedReader) = collect(eltype(reader), reader.reader)