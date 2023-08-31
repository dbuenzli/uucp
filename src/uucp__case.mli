(*---------------------------------------------------------------------------
   Copyright (c) 2013 The uucp programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)


(** Case properties, mappings and foldings.

    These properties can implement Unicode's default case detection,
    case conversion and caseless equality over Unicode text, see the
    {{!Case.caseexamples}examples}.

    {3 References}
    {ul
    {- {{:http://unicode.org/faq/casemap_charprop.html#casemap}
        The Unicode case mapping FAQ.}}
    {- {{:http://www.unicode.org/charts/case/}The Unicode case mapping
       charts.}}} *)

(** {1:caseprops Case properties} *)

val is_lower : Uchar.t -> bool
(** [is_lower u] is [true] iff [u] has the
    {{:http://www.unicode.org/reports/tr44/#Lowercase}Lowercase} derived
    property. *)

val is_upper : Uchar.t -> bool
(** [is_upper u] is [true] iff [u] has the
    {{:http://www.unicode.org/reports/tr44/#Uppercase}Uppercase} derived
    property. *)

val is_cased : Uchar.t -> bool
(** [is_cased u] is [true] iff [u] has the
    {{:http://www.unicode.org/reports/tr44/#Cased}Cased} derived property. *)

val is_case_ignorable : Uchar.t -> bool
(** [is_case_ignorable] is [true] iff [u] has the
    {{:http://www.unicode.org/reports/tr44/#Case_Ignorable}Case_Ignorable}
    derived property. *)

(** {1:casemapfold Case mappings and foldings}

    These character mapping functions return [`Self]
    whenever a character maps to itself. *)


module Map = Uucp__case_map
module Fold = Uucp__case_fold
module Nfkc_fold = Uucp__case_nfkc

(** {1:caseexamples Examples}

    These examples use {!Uutf} to fold over the characters of UTF-8
    encoded OCaml strings and to UTF-8 encode mapped characters in
    an OCaml {!Buffer.t} value.

    {2:caseconversion Default case conversion on UTF-8 strings}

    The value [casemap_utf_8 cmap s] is the UTF-8 encoded string
    resulting from applying the character map [cmap] to every character
    of the UTF-8 encoded string [s].

{[
let cmap_utf_8 cmap s =
  let b = Buffer.create (String.length s * 2) in
  let rec add_map _ _ u =
    let u = match u with `Malformed _ -> Uutf.u_rep | `Uchar u -> u in
    match cmap u with
    | `Self -> Uutf.Buffer.add_utf_8 b u
    | `Uchars us -> List.iter (Uutf.Buffer.add_utf_8 b) us
  in
  Uutf.String.fold_utf_8 add_map () s; Buffer.contents b
]}

    Using the function [cmap_utf_8], Unicode's default case
    conversions can be implemented with:

{[
let lowercase_utf_8 s = cmap_utf_8 Uucp.Case.Map.to_lower s
let uppercase_utf_8 s = cmap_utf_8 Uucp.Case.Map.to_upper s
]}

    However strictly speaking [lowercase_utf_8] is not conformant
    as it doesn't handle the context sensitive mapping of capital
    sigma U+03A3 to final sigma U+03C2.

    Note that applying Unicode's default case algorithms to a normalized
    string does not preserve its normalization form.

    {2:caselesseq Default caseless matching (equality) on UTF-8 strings}

    These examples use {!Uunf} to normalize character sequences

    Unicode canonical caseless matching (D145) is defined by
    normalizing to NFD, applying the Case_Folding mapping, normalizing
    again to NFD and test the result for binary equality:

{[
let canonical_caseless_key s =
  let b = Buffer.create (String.length s * 2) in
  let to_nfd_and_utf_8 =
    let n = Uunf.create `NFD in
    let rec add v = match Uunf.add n v with
    | `Await | `End -> ()
    | `Uchar u -> Uutf.Buffer.add_utf_8 b u; add `Await
    in
    add
  in
  let add =
    let n = Uunf.create `NFD in
    let rec add v = match Uunf.add n v with
    | `Await | `End -> ()
    | `Uchar u ->
        begin match Uucp.Case.Fold.fold u with
        | `Self -> to_nfd_and_utf_8 (`Uchar u)
        | `Uchars us -> List.iter (fun u -> to_nfd_and_utf_8 (`Uchar u)) us
        end;
        add `Await
    in
    add
  in
  let add_uchar _ _ = function
  | `Malformed  _ -> add (`Uchar Uutf.u_rep)
  | `Uchar _ as u -> add u
  in
  Uutf.String.fold_utf_8 add_uchar () s;
  add `End;
  to_nfd_and_utf_8 `End;
  Buffer.contents b

let canonical_caseless_eq s0 s1 =
  canonical_caseless_key s0 = canonical_caseless_key s1
]}

    Unicode's caseless matching for identifiers (D147, see also
    {{:http://www.unicode.org/reports/tr31/}UAX 31}) is defined
    by normalizing to NFD, applying the NFKC_Casefold mapping and test
    the result for binary equality:

{[
let id_caseless_key s =
  let b = Buffer.create (String.length s * 3) in
  let n = Uunf.create `NFD in
  let rec add v = match Uunf.add n v with
  | `Await | `End -> ()
  | `Uchar u ->
      begin match Uucp.Case.Nfkc_fold.fold u with
      | `Self -> Uutf.Buffer.add_utf_8 b u; add `Await
      | `Uchars us -> List.iter (Uutf.Buffer.add_utf_8 b) us; add `Await
      end
  in
  let add_uchar _ _ = function
  | `Malformed  _ -> add (`Uchar Uutf.u_rep)
  | `Uchar _ as u -> add u
  in
  Uutf.String.fold_utf_8 add_uchar () s;
  add `End;
  Buffer.contents b

let id_caseless_eq s0 s1 = id_caseless_key s0 = id_caseless_key s1
]}
*)
