# TypedFASTX

[![Latest Release](https://img.shields.io/github/release/anton083/TypedFASTX.jl.svg)](https://github.com/anton083/TypedFASTX.jl/releases/latest)
[![MIT license](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/license/MIT)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://anton083.github.io/TypedFASTX.jl/stable/)
[![Status](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/anton083/TypedFASTX.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/anton083/TypedFASTX.jl)
<!-- [![Build Status](https://travis-ci.com/anton083/TypedFASTX.jl.svg?branch=master)](https://travis-ci.com/anton083/TypedFASTX.jl) -->

TypedFASTX.jl is a Julia package for working with FASTA and FASTQ files using strongly typed records. It is largely based on [BioJulia's FASTX.jl package](https://github.com/BioJulia/FASTX.jl), whose records are un-typed, i.e. they are agnostic to the kind of data they contain. TypedFASTX.jl aims to enhance readability, reduce the potential for errors by enforcing type safety, and enable you to define different methods for different record types.

## Install

To install the package, you can use the Julia package manager. From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```julia
add TypedFASTX
```
NOTE: TypedFASTX is not yet registered, so this will not work.

## Usage
Here is a basic example of how to use the package:

```julia
using TypedFASTX, BioSequences, FASTX

record1 = DNARecord("Ricky", "ACGTA")
record2 = TypedRecord("Ricky", dna"ACGTA")
record3 = DNARecord(FASTARecord("Ricky", "ACGTA"))

println(record1 == record2 == record3) # true
```

Please refer to the documentation for more detailed information on how to use the TypedFASTX.jl package.

## Contributing
Contributions are very welcome! I don't really know how that stuff works; GPT-4 suggests: "If you'd like to contribute, please fork the repository and use a feature branch."
