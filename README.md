# <img width="25%" src="./docs/sticker.svg" align="right" /> TypedFASTX

[![Latest Release](https://img.shields.io/github/release/anton083/TypedFASTX.jl.svg)](https://github.com/anton083/TypedFASTX.jl/releases/latest)
[![MIT license](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/license/MIT)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://anton083.github.io/TypedFASTX.jl/stable/)
[![Status](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/anton083/TypedFASTX.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/anton083/TypedFASTX.jl)

TypedFASTX.jl is a Julia package for working with FASTA and FASTQ files using typed records. It is largely based on BioJulia's [FASTX.jl](https://github.com/BioJulia/FASTX.jl) package, whose records are un-typed, i.e. they are agnostic to what kind of data they contain. Besides from the sequence field, the TypedRecord type also has an identifier and an optional quality field.
TypedFASTX.jl aims to enhance readability and reduce potential errors when dealing with different types of biological sequences. It also enforces type safety and allows you to define different methods for specific record types.

## Performance
TypedRecords generally take up less memory than FASTX.jl records, since [BioSequences.jl](https://github.com/BioJulia/BioSequences.jl)'s LongSequence type stores sequence information more efficiently. However, this approach might be slightly slower compared to, for instance, storing each field in its own vector, due to the additional overhead required to keep it flexible and user-friendly.
TypedRecords also take more time to write to files, as the sequences need to be encoded back to ASCII to be stored in FASTA/FASTQ format. As it currently stands, TypedFASTX.jl should perhaps not be used if writing records to files is a potential bottleneck for the speed of your program. When it comes to reading, it should be about as fast as just using plain FASTX.jl.

## Installation

To install the package, you can use the Julia package manager. From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```
add TypedFASTX
```

## Example
You can create TypedRecords in a variety of ways! Here are some ways to create DNA records (without qualities):

```julia
using TypedFASTX, BioSequences, FASTX

record1 = DNARecord("Ricky", "ACGTA")
record2 = DNARecord(FASTARecord("Ricky", "ACGTA"))
record3 = TypedRecord("Ricky", dna"ACGTA")
record4 = TypedRecord{LongDNA{4}}("Ricky", "ACGTA")

record1 == record2 == record3 == record4 # true
```

Check out the documentation for more detailed information on how to use the package.

## Contributing
Contributions are very welcome! If you'd like to contribute, GPT-4 suggests forking the repository and using a feature branch.
