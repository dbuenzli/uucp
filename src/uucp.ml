(*---------------------------------------------------------------------------
   Copyright (c) 2014 The uucp programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

(* Unicode version *)

let unicode_version = Uucp_version_data.unicode_version

(* Properties *)

module Age = Uucp_age
module Alpha = Uucp_alpha
module Break = Uucp_break
module Block = Uucp_block
module Case = Uucp_case
module Cjk = Uucp_cjk
module Emoji = Uucp_emoji
module Func = Uucp_func
module Gc = Uucp_gc
module Gen = Uucp_gen
module Hangul = Uucp_hangul
module Id = Uucp_id
module Name = Uucp_name
module Num = Uucp_num
module Script = Uucp_script
module White = Uucp_white

(* Maps. Not part of the public API. *)

module Cmap = Uucp_cmap
module Rmap = Uucp_rmap
module Tmap = Uucp_tmap
module Tmapbool = Uucp_tmapbool
module Tmapbyte = Uucp_tmapbyte
