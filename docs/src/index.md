```@meta
CurrentModule = TypedFASTX
DocTestSetup = quote
    using TypedFASTX, FASTX, BioSequences
end
```

# TypedFASTX
[![Latest Release](https://img.shields.io/github/release/anton083/TypedFASTX.jl.svg)](https://github.com/anton083/TypedFASTX.jl/releases/latest)
[![MIT license](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/license/MIT)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://anton083.github.io/TypedFASTX.jl/stable/)
[![Status](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/anton083/TypedFASTX.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/anton083/TypedFASTX.jl)

FASTX records with typed sequences and optional qualities.

## Installation
You can install TypedFASTX from the Julia REPL. Type `]` to enter the Pkg REPL mode and run:

```jldoctest
(@v1.9) pkg> add TypedFASTX
```

## Quickstart
Like FASTX.jl, TypedFASTX.jl is used for handling FASTA and FASTQ files. The main difference is that the sequence field is typed (it is not just a raw array of ASCII bytes). Records can be created using the TypedFASTA and TypedFASTQ modules.

* Construct a FASTA record:
```jldoctest
julia> record = DNARecord("ricky the record", "GATTACA");

julia> sequence(record)
7nt DNA Sequence:
GATTACA

julia> (identifier(record), description(record), sequence(record))
("ricky", "ricky the record", GATTACA)
```