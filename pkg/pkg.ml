#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let uutf = Conf.with_pkg "uutf"
let uunf = Conf.with_pkg "uunf"
let cmdliner = Conf.with_pkg "cmdliner"

let () =
  Pkg.describe "uucp" @@ fun c ->
  let uutf = Conf.value c uutf in
  let uunf = Conf.value c uunf in
  let cmdliner = Conf.value c cmdliner in
  Ok [ Pkg.mllib ~api:["Uucp"] "src/uucp.mllib";
       Pkg.bin ~cond:(uutf && uunf && cmdliner) "test/ucharinfo";
       Pkg.test ~run:false "test/test";
       Pkg.test "test/perf";
       Pkg.test "test/examples";
       Pkg.test "test/link_test";
       Pkg.doc "doc/index.mld" ~dst:"odoc-pages/index.mld";
       Pkg.doc "doc/unicode.mld" ~dst:"odoc-pages/unicode.mld";
       Pkg.doc "DEVEL.md";
       Pkg.doc "test/examples.ml"; ]
