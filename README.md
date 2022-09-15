Uucp — Unicode character properties for OCaml
-------------------------------------------------------------------------------
%%VERSION%%

Uucp is an OCaml library providing efficient access to a selection of
character properties of the [Unicode character database][1].

Uucp is independent from any Unicode text data structure and has no
dependencies. It is distributed under the ISC license.

[1]: http://www.unicode.org/reports/tr44/

Home page: http://erratique.ch/software/uucp  

## Installation

Uucp can be installed with `opam`:

    opam install uucp
    opam install cmdliner uutf uunf uucp # for ucharinfo cli tool

If you don't use `opam` consult the [`opam`](opam) file for build
instructions and a complete specification of the dependencies.


## Documentation

The documentation can be consulted [online][doc] or via `odig doc uucp`.

Uucp's documentation also has a [minimal Unicode introduction][intro] and
some [Unicode OCaml tips][tips].

Questions are welcome but better asked on the [OCaml forum][ocaml-forum] 
than on the issue tracker.

[doc]: http://erratique.ch/software/uucp/doc/
[intro]: http://erratique.ch/software/uucp/doc/unicode.html#minimal
[tips]: http://erratique.ch/software/uucp/doc/unicode.html#tips
[ocaml-forum]: https://discuss.ocaml.org/


## Sample programs

The `ucharinfo` tool allows to report character information on the
command line.

Sample programs are located in the `test` directory of the
distribution. They can be built with:

    topkg build --tests true
    
The resulting binaries are in `_build/test` :

- `test.native` tests the library. Nothing should fail.
- `perf.native` tests the performance of the library.
