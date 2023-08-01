# <img width="25%" src="./docs/sticker.svg" align="right" /> TypedFASTX

[![Latest Release](https://img.shields.io/github/release/anton083/TypedFASTX.jl.svg)](https://github.com/anton083/TypedFASTX.jl/releases/latest)
[![MIT license](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/license/MIT)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://anton083.github.io/TypedFASTX.jl/stable/)
[![Status](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/anton083/TypedFASTX.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/anton083/TypedFASTX.jl)

TypedFASTX.jl is a Julia package for working with FASTA and FASTQ files using typed records. It is largely based on BioJulia's [FASTX.jl](https://github.com/BioJulia/FASTX.jl) package, whose records are un-typed, i.e. they are agnostic to what kind of data they contain. Besides from the sequence field, the TypedRecord type also has an description and an optional quality field.
TypedFASTX.jl aims to enhance readability and reduce potential errors when dealing with different types of biological sequences. It also allows you to define different methods for specific record types.

## Performance
TypedRecords generally take up less memory than FASTX.jl records, since [BioSequences.jl](https://github.com/BioJulia/BioSequences.jl)'s LongSequence type stores sequence information more efficiently. However, this approach might be slightly slower compared to, for instance, storing each field in its own vector, due to the additional overhead required to keep it flexible and user-friendly.
TypedFASTX.jl is a little slower than FASTX.jl at writing records to files, as the sequences need to be encoded back to ASCII bytes (which is done through string interpolation) to be stored in FASTA/FASTQ format. One benchmark showed that writing records takes about twice as long compared to FASTX.jl. When it comes to reading, it should be almost as fast as just using plain FASTX.jl (including sequence type conversions).

## Installation

You can install TypedFASTX from the Julia REPL. Type `]` to enter the Pkg REPL mode and run:

```
(@v1.9) pkg> add TypedFASTX
```

## Example usage

```julia
julia> using TypedFASTX, FASTX, BioSequences

julia> ricky = AARecord("Ricky Smith", "SMITH")
TypedFASTX.TypedFASTA.Record{LongAA}:
 description: "Ricky Smith"
    sequence: "SMITH"

julia> sequence(ricky)
5aa Amino Acid Sequence:
SMITH

julia> mickey = DNARecord("Mickey Smith", "GATTACA", "quAliTy") # quality is optional
TypedFASTX.TypedFASTQ.Record{LongSequence{DNAAlphabet{4}}}:
 description: "Mickey Smith"
    sequence: "GATTACA"
     quality: "quAl!Ty"

julia> sequence(mickey)
7nt DNA Sequence:
GATTACA

julia> sequence(String, mickey)
"GATTACA"

julia> error_rate(mickey)
9.128727304334052e-5

julia> description(mickey)
"Mickey Smith"

julia> identifier(mickey)
"Mickey"
```

Check out the documentation for more detailed information on how to use the package.

## Contributing
Contributions are very welcome! If you'd like to contribute, GPT-4 suggests forking the repository and using a feature branch.
