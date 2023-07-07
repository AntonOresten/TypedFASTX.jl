# TypedFASTX

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://anton083.github.io/TypedFASTX.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://anton083.github.io/TypedFASTX.jl/dev/)
[![Build Status](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/anton083/TypedFASTX.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Build Status](https://travis-ci.com/anton083/TypedFASTX.jl.svg?branch=master)](https://travis-ci.com/anton083/TypedFASTX.jl)
[![Coverage](https://codecov.io/gh/anton083/TypedFASTX.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/anton083/TypedFASTX.jl)

TypedFASTX.jl is a Julia package for working with FASTA and FASTQ files using strongly typed records. It is largely based on BioJulia's FASTX.jl package, whose records are un-typed, i.e. they are agnostic to the kind of data they contain. TypedFASTX.jl aims to enhances readability, reduce the potential for errors by enforcing type safety, and enable you to define different methods for different record types.

## Getting Started

To install the package, you can use the Julia package manager. From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```julia
pkg> add TypedFASTX
```

## Usage
Here is a basic example of how to use the package:

```julia
using TypedFASTX

rec1 = DNARecord(FASTARecord("Rick", "ACGTA"))
```

Please refer to the documentation for more detailed information on how to use the TypedFASTX.jl package.

## Contributing
Contributions are very welcome! I don't really know how that stuff works; GPT-4 suggests: "If you'd like to contribute, please fork the repository and use a feature branch."

## License

TypedFASTX is released under the [MIT License](https://opensource.org/license/MIT)

