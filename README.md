Uucp — Unicode character properties for OCaml
-------------------------------------------------------------------------------
%%VERSION%% — Unicode version %%UNICODE_VERSION%%

Uucp is an OCaml library providing efficient access to a selection of
character properties of the [Unicode character database][1].

Uucp is independent from any Unicode text data structure and has no
dependencies. It is distributed under the ISC license.

[1]: http://www.unicode.org/reports/tr44/

Home page: http://erratique.ch/software/uucp  
Contact: Daniel Bünzli `<daniel.buenzl i@erratique.ch>`


## Installation

Uucp can be installed with `opam`:

    opam install uucp

If you don't use `opam` consult the [`opam`](opam) file for build
instructions and a complete specification of the dependencies.


## Documentation

Uucp has a [minimal Unicode introduction][intro] and some
[Unicode OCaml tips][tips].

The documentation and API reference is automatically generated from
the interfaces. It can be consulted [online][doc] or via `odig doc
uucp`.

[doc]: http://erratique.ch/software/uucp/doc/
[intro]: http://erratique.ch/software/uucp/doc/Uucp.html#uminimal
[tips]: http://erratique.ch/software/uucp/doc/Uucp.html#tips


## Sample programs

Sample programs are located in the `test` directory of the
distribution. They can be built with:

    topkg build --tests true
    
The resulting binaries are in `_build/test` :

- `test.native` tests the library. Nothing should fail.
- `perf.native` tests the performance of the library.

## Authors

* [Daniel C. Bünzli](http://erratique.ch), main developer.
* David Kaloper Meršinjak, `Uucp.Break.tty_width_hint` function.

