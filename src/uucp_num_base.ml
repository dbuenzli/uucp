(*---------------------------------------------------------------------------
   Copyright (c) 2014 The uucp programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

type numeric_type = [ `De | `Di | `None | `Nu ]
type numeric_value = [ `Frac of int * int | `NaN | `Num of int64 ]

let pp_numeric_type ppf v = Format.fprintf ppf "%s" begin match v with
  | `De -> "De"
  | `Di -> "Di"
  | `None -> "None"
  | `Nu -> "Nu"
  end

let pp_numeric_value ppf = function
| `NaN -> Format.fprintf ppf "NaN"
| `Frac (a, b) -> Format.fprintf ppf "Frac(%d,%d)" a b
| `Num n -> Format.fprintf ppf "Num(%LdL)" n
