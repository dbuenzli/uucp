(*---------------------------------------------------------------------------
   Copyright (c) 2013 The uucp programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

(* Case properties *)

let is_upper u = Uucp_tmapbool.get Uucp_case_data.upper_map (Uchar.to_int u)
let is_lower u = Uucp_tmapbool.get Uucp_case_data.lower_map (Uchar.to_int u)
let is_cased u = Uucp_tmapbool.get Uucp_case_data.cased_map (Uchar.to_int u)
let is_case_ignorable u =
  Uucp_tmapbool.get Uucp_case_data.case_ignorable_map (Uchar.to_int u)

(* Case mappings *)

module Map = Uucp_case_map
module Fold = Uucp_case_fold
module Nfkc_fold = Uucp_case_nfkc
