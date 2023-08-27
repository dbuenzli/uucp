(*---------------------------------------------------------------------------
   Copyright (c) 2014 The uucp programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

let pp_numeric_type ppf ucd =
  let size v = 0 in
  let pp_ntype ppf t = Gen.pp ppf "`%a" Uucp_num_base.pp_numeric_type t in
  Gen.pp_prop_rmap_ucd ~share:false ppf ucd Uucd.numeric_type
    "numeric_type" "Uucp_num_base.numeric_type" pp_ntype
    ~default:`None size

let pp_numeric_value ppf ucd =
  let size = function
  | `NaN -> 0
  | `Frac _ -> 1 + 2
  | `Num _ -> 1 + (64 / Sys.word_size)
  in
  let pp_nvalue ppf v = Gen.pp ppf "(`%a)" Uucp_num_base.pp_numeric_value v in
  Gen.pp_prop_cmap_ucd ppf ucd Uucd.numeric_value
    "numeric_value" "Uucp_num_base.numeric_value" pp_nvalue
    ~default:`NaN size

let pp_props ppf ucd =
  let prop = Gen.pp_prop_tmapbool_ucd ppf ucd in
  prop Uucd.ascii_hex_digit "ascii_hex_digit";
  prop Uucd.hex_digit "hex_digit";
  pp_numeric_type ppf ucd;
  pp_numeric_value ppf ucd;
  ()

let pp_mod ppf ucd = Gen.pp_mod pp_props ppf ucd
