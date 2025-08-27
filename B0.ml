open B0_kit.V000
open Result.Syntax

let unicode_version = 17, 0, 0, None (* Adjust on new releases *)
let next_major = B0_version.next_major unicode_version

(* OCaml library names *)

let b0_std = B0_ocaml.libname "b0.std"
let unix = B0_ocaml.libname "unix"
let uucd = B0_ocaml.libname "uucd"
let uunf = B0_ocaml.libname "uunf"
let cmdliner = B0_ocaml.libname "cmdliner"

let uucp = B0_ocaml.libname "uucp"

(* Libraries *)

let uucp_lib = B0_ocaml.lib uucp ~srcs:[ `Dir ~/"src" ]

(* Data generation. *)

let generate_data =
  let doc = "uucp_*_data.ml files generator" in
  let srcs =
    [ `Dir ~/"support";
      (* Well that was based on ocamlbuild loose' inclusion,
         maybe we could move all that to a single _base.ml module. *)
      `File ~/"src/uucp_block_base.ml";
      `File ~/"src/uucp_break_base.ml";
      `File ~/"src/uucp_gc_base.ml";
      `File ~/"src/uucp_hangul_base.ml";
      `File ~/"src/uucp_name_base.ml";
      `File ~/"src/uucp_num_base.ml";
      `File ~/"src/uucp_script_base.ml";
      (* *)
      `File ~/"src/uucp_cmap.ml";
      `File ~/"src/uucp_fmt.ml";
      `File ~/"src/uucp_rmap.ml";
      `File ~/"src/uucp_tmap.ml";
      `File ~/"src/uucp_tmap5bytes.ml";
      `File ~/"src/uucp_tmapbool.ml";
      `File ~/"src/uucp_tmapbyte.ml"; ]
  in
  let requires = [ uucd; unix ] in
  let meta =
    B0_meta.empty
    |> B0_meta.(tag build)
    |> ~~ B0_unit.Action.cwd `Scope_dir
  in
  B0_ocaml.exe "generate-data" ~doc ~srcs ~requires ~meta

(* Tools *)

let ucharinfo =
  let doc = "The ucharinfo tool" in
  let srcs = [ `File ~/"test/ucharinfo.ml" ] in
  let requires = [ cmdliner; uunf; uucp ] in
  B0_ocaml.exe "ucharinfo" ~public:true ~doc ~srcs ~requires

(* Tests *)

let test ?doc ?(meta = B0_meta.empty) ?run:(r = false) ?(requires = []) src =
  let srcs = [ `File src ] in
  let requires = uucp :: requires in
  let meta = B0_meta.(meta |> tag test |> add run r) in
  let name = Fpath.basename ~strip_exts:true src in
  B0_ocaml.exe name ?doc ~srcs ~meta ~requires

let test_uucp =
  let doc = "Test Uucp against the Unicode database." in
  let meta = B0_meta.empty |> ~~ B0_unit.Action.cwd `Scope_dir in
  test ~/"test/test_uucp.ml" ~requires:[uucd; b0_std] ~meta ~run:true ~doc

let perf = test ~/"test/perf.ml" ~doc:"Test performance"
let link_test = test ~/"test/link_test.ml" ~doc:"Link test"
let examples = test ~/"test/examples.ml" ~requires:[uunf] ~doc:"Doc samples"

(* Actions *)

let uc_base = "http://www.unicode.org/Public"

let show_version =
  B0_unit.of_action "unicode-version" ~doc:"Show supported unicode version" @@
  fun _ _ ~args:_ ->
  Ok (Log.stdout (fun m -> m "%s" (B0_version.to_string unicode_version)))

let download_ucdxml =
  let doc = "Download the ucdxml to support/ucd.xml" in
  B0_unit.of_action "download-ucdxml" ~doc @@ fun env _ ~args:_ ->
  let* unzip = B0_env.get_cmd env (Cmd.tool "unzip") in
  let version = B0_version.to_string unicode_version in
  let ucd_url = Fmt.str "%s/%s/ucdxml/ucd.all.grouped.zip" uc_base version in
  let ucd_file = B0_env.in_scope_dir env ~/"support/ucd.xml" in
  Result.join @@ Os.File.with_tmp_fd @@ fun tmpfile tmpfd ->
  (Log.stdout @@ fun m ->
   m "@[<v>Downloading %s@,to %a@]" ucd_url Fpath.pp ucd_file);
  let* () = B0_action_kit.fetch_url env ucd_url tmpfile in
  let stdout = Os.Cmd.out_file ~force:true ~make_path:true ucd_file in
  Os.Cmd.run Cmd.(unzip % "-p" %% path tmpfile) ~stdout

(* Packs *)

let default =
  let unicode_version = B0_version.to_string unicode_version in
  let next_major = B0_version.to_string next_major in
  let meta =
    B0_meta.empty
    |> ~~ B0_meta.authors ["The uucp programmers"]
    |> ~~ B0_meta.maintainers ["Daniel Bünzli <daniel.buenzl i@erratique.ch>"]
    |> ~~ B0_meta.homepage "https://erratique.ch/software/uucp"
    |> ~~ B0_meta.online_doc "https://erratique.ch/software/uucp/doc/"
    |> ~~ B0_meta.licenses ["ISC"]
    |> ~~ B0_meta.repo "git+https://erratique.ch/repos/uucp.git"
    |> ~~ B0_meta.issues "https://github.com/dbuenzli/uucp/issues"
    |> ~~ B0_meta.description_tags
      ["unicode"; "text"; "character"; "org:erratique"]
    |> ~~ B0_opam.build
      {|[["ocaml" "pkg/pkg.ml" "build" "--dev-pkg" "%{dev}%"
         "--with-uunf" "%{uunf:installed}%"
         "--with-cmdliner" "%{cmdliner:installed}%" ]]|}
    |> B0_meta.tag B0_opam.tag
    |> ~~ B0_opam.depopts [ "uunf", ""; "cmdliner", ""]
    |> ~~ B0_opam.conflicts
      [ "uunf", Fmt.str {|< "%s" | >= "%s" |} unicode_version next_major;
        "cmdliner", {|< "1.1.0"|} ]
    |> ~~ B0_opam.depends
      [ "ocaml", {|>= "4.14.0"|};
        "ocamlfind", {|build|};
        "ocamlbuild", {|build|};
        "topkg", {|build & >= "1.1.0"|};
        "uucd", Fmt.str {|with-test dev & >= "%s" & < "%s"|}
          unicode_version next_major;
        "uunf", {|with-test|} ]
    |> ~~ B0_opam.file_addendum
      [ `Field ("post-messages", `L (true, [
            `S "If the build fails with \"ocamlopt.opt got signal and \
                exited\", issue 'ulimit -s unlimited' and retry.";
            `Raw {|{failure & (arch = "ppc64" | arch = "arm64")}|}]))]
  in
  B0_pack.make "default" ~doc:"uucd package" ~meta ~locked:true @@
  B0_unit.list ()
