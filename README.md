# TypedFASTX

[![Latest Release](https://img.shields.io/github/release/anton083/TypedFASTX.jl.svg)](https://github.com/anton083/TypedFASTX.jl/releases/latest)
[![MIT license](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/license/MIT)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://anton083.github.io/TypedFASTX.jl/stable/)
[![Status](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/anton083/TypedFASTX.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/anton083/TypedFASTX.jl)
<!-- [![Build Status](https://travis-ci.com/anton083/TypedFASTX.jl.svg?branch=main)](https://travis-ci.com/anton083/TypedFASTX.jl) -->

TypedFASTX.jl is a Julia package for working with FASTA and FASTQ files using typed records. It is largely based on BioJulia's [FASTX.jl](https://github.com/BioJulia/FASTX.jl) package, whose records are un-typed, i.e. they are agnostic to what kind of data they contain. Besides from the sequence field, the TypedRecord type also has an identifier and an optional quality field.
TypedFASTX.jl aims to enhance readability and reduce potential errors when dealing with different types of biological sequences. It also enforces type safety and allows you to define different methods for specific record types.

## Performance
TypedRecords generally take up less memory than FASTX.jl records, since [BioSequences.jl](https://github.com/BioJulia/BioSequences.jl)'s LongSequence type stores sequence information more efficiently. It may however be slightly slower compared to let's say, storing each field in its own vector, due to the overhead required to keep it flexible and user-friendly. The optional quality field is also something that might affect performance; the current implementation can't force the quality field of records in an array to be consistent (as they can be either `Nothing` or `Vector{Int8}`).

## Install

To install the package, you can use the Julia package manager. From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```
add TypedFASTX
```

## Usage
Here is a basic example of how to use the package:

```julia
using TypedFASTX, BioSequences, FASTX

record1 = DNARecord("Ricky", "ACGTA")
record2 = TypedRecord("Ricky", dna"ACGTA")
record3 = DNARecord(FASTARecord("Ricky", "ACGTA"))

record1 == record2 == record3 # true
```

Please refer to the (not yet written) documentation for more detailed information on how to use the TypedFASTX.jl package.

## Contributing
Contributions are very welcome! If you'd like to contribute, please fork the repository and use a feature branch.
