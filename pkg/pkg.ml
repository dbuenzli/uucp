#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let uutf = Conf.with_pkg "uutf"
let uunf = Conf.with_pkg "uunf"
let cmdliner = Conf.with_pkg "cmdliner"

let uucp_api =
  [ "Uucp";
    "Uucp__age";
    "Uucp__alpha";
    "Uucp__block";
    "Uucp__break";
    "Uucp__case";
    "Uucp__case_fold";
    "Uucp__case_map";
    "Uucp__case_nfkc";
    "Uucp__cjk";
    "Uucp__emoji";
    "Uucp__func";
    "Uucp__gc";
    "Uucp__gen";
    "Uucp__hangul";
    "Uucp__id";
    "Uucp__name";
    "Uucp__num";
    "Uucp__script";
    "Uucp__white"; ]

let () =
  Pkg.describe "uucp" @@ fun c ->
  let uutf = Conf.value c uutf in
  let uunf = Conf.value c uunf in
  let cmdliner = Conf.value c cmdliner in
  Ok [ Pkg.mllib ~api:uucp_api "src/uucp.mllib";
       Pkg.bin ~cond:(uutf && uunf && cmdliner) "test/ucharinfo";
       Pkg.test ~run:false "test/test";
       Pkg.test "test/perf";
       Pkg.test "test/examples";
       Pkg.test "test/link_test";
       Pkg.doc "doc/index.mld" ~dst:"odoc-pages/index.mld";
       Pkg.doc "doc/unicode.mld" ~dst:"odoc-pages/unicode.mld";
       Pkg.doc "DEVEL.md";
       Pkg.doc "test/examples.ml"; ]
