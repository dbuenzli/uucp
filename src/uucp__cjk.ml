(*---------------------------------------------------------------------------
   Copyright (c) 2014 The uucp programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

let is_ideographic u =
  Uucp_tmapbool.get Uucp_cjk_data.ideographic_map (Uchar.to_int u)

let is_ids_bin_op u =
  Uucp_tmapbool.get Uucp_cjk_data.ids_bin_op_map (Uchar.to_int u)

let is_ids_tri_op u =
  Uucp_tmapbool.get Uucp_cjk_data.ids_tri_op_map (Uchar.to_int u)

let is_radical u =
  Uucp_tmapbool.get Uucp_cjk_data.radical_map (Uchar.to_int u)

let is_unified_ideograph u =
  Uucp_tmapbool.get Uucp_cjk_data.unified_ideograph_map (Uchar.to_int u)
