open B0_kit.V000
open Result.Syntax

let unicode_version = 15, 0, 0, None (* Adjust on new releases *)
let next_major = let maj, _, _, _ = unicode_version in (maj + 1), 0, 0, None

(* OCaml library names *)

let uucd = B0_ocaml.libname "uucd"
let uunf = B0_ocaml.libname "uunf"
let cmdliner = B0_ocaml.libname "cmdliner"

let uucp = B0_ocaml.libname "uucp"

(* Libraries *)

let uucp_lib =
  let srcs = Fpath.[ `Dir (v "src") ] in
  let requires = [] in
  B0_ocaml.lib uucp ~doc:"The uucp library" ~srcs ~requires

(* Data generation. *)

let generate_data =
  let srcs = [ `Dir (Fpath.v "support");
               (* Well that was based on ocamlbuild loose' inclusion,
                  maybe we could move all that to a single _base.ml module. *)
               `File (Fpath.v "src/uucp_block_base.ml");
               `File (Fpath.v "src/uucp_break_base.ml");
               `File (Fpath.v "src/uucp_gc_base.ml");
               `File (Fpath.v "src/uucp_hangul_base.ml");
               `File (Fpath.v "src/uucp_name_base.ml");
               `File (Fpath.v "src/uucp_num_base.ml");
               `File (Fpath.v "src/uucp_script_base.ml");
               (* *)
               `File (Fpath.v "src/uucp_cmap.ml");
               `File (Fpath.v "src/uucp_fmt.ml");
               `File (Fpath.v "src/uucp_rmap.ml");
               `File (Fpath.v "src/uucp_tmap.ml");
               `File (Fpath.v "src/uucp_tmap5bytes.ml");
               `File (Fpath.v "src/uucp_tmapbool.ml");
               `File (Fpath.v "src/uucp_tmapbyte.ml"); ]
  in
  let requires = [uucd] in
  let meta =
    let scope_dir b u = Fut.return (B0_build.scope_dir b u) in
    B0_meta.(empty |> add B0_unit.Action.exec_cwd scope_dir)
  in
  let doc = "uucp_*_data.ml files generator" in
  B0_ocaml.exe "generate-data" ~doc ~srcs ~requires ~meta

(* Tools *)

let ucharinfo =
  let srcs = Fpath.[`File (v "test/ucharinfo.ml")] in
  let requires = [cmdliner; uunf; uucp] in
  B0_ocaml.exe "ucharinfo" ~doc:"The ucharinfo tool" ~srcs ~requires

(* Tests *)

let test ?(meta = B0_meta.empty) ?(requires = [uucp]) name ~src ~doc =
  let srcs = Fpath.[`File (v src)] in
  let meta = B0_meta.(meta |> tag test) in
  B0_ocaml.exe name ~doc ~srcs ~meta ~requires

let test' =
  (* FIXME b0, this is not so good. *)
  let meta =
    let scope_dir b u = Fut.return (B0_build.scope_dir b u) in
    B0_meta.(empty |> add B0_unit.Action.exec_cwd scope_dir)
  in
  test "test" ~requires:[uucd; uucp] ~src:"test/test.ml"
    ~doc:"Test Uucp against the Unicode database." ~meta

let perf =
  test "perf" ~requires:[uucp] ~src:"test/perf.ml" ~doc:"Test performance"

let link_test =
  test "link_test" ~requires:[uucp] ~src:"test/link_test.ml" ~doc:"Link test"

let examples =
  let doc = "Doc samples" in
  test "examples" ~requires:[uucp; uunf] ~src:"test/examples.ml" ~doc

(* Cmdlets *)

let uc_base = "http://www.unicode.org/Public"

let unzip () = Os.Cmd.get (Cmd.arg "unzip")
let curl () =
  Os.Cmd.get @@
  Cmd.(arg "curl" % "--fail" % "--show-error" % "--progress-bar" % "--location")

let show_version =
  B0_cmdlet.v "unicode-version" ~doc:"Show supported unicode version" @@
  fun env _args -> B0_cmdlet.exit_of_result @@
  (Log.app (fun m -> m "%s" (String.of_version unicode_version));
   Ok ())

let download_ucdxml =
  B0_cmdlet.v "download-ucdxml" ~doc:"Download the ucdxml" @@
  fun env _args -> B0_cmdlet.exit_of_result @@
  let version = String.of_version unicode_version in
  let ucd_uri = Fmt.str "%s/%s/ucdxml/ucd.all.grouped.zip" uc_base version in
  let ucd_file = Fpath.v "support/ucd.xml" in
  let ucd_file = B0_cmdlet.in_scope_dir env ucd_file in
  let* curl = curl () and* unzip = unzip () in
  Result.join @@ Os.File.with_tmp_fd @@ fun tmpfile tmpfd ->
  Log.app (fun m ->
      m "@[<v>Downloading %s@,to %a@]" ucd_uri Fpath.pp ucd_file);
  let stdout = Os.Cmd.out_fd ~close:true tmpfd in
  let* () = Os.Cmd.run Cmd.(curl % ucd_uri) ~stdout in
  let stdout = Os.Cmd.out_file ~force:true ~make_path:true ucd_file in
  let* () = Os.Cmd.run Cmd.(unzip % "-p" %% path tmpfile) ~stdout in
  Ok ()

(* Packs *)

let default =
  let meta =
    let open B0_meta in
    empty
    |> add authors ["The uucp programmers"]
    |> add maintainers ["Daniel Bünzli <daniel.buenzl i@erratique.ch>"]
    |> add homepage "https://erratique.ch/software/uucp"
    |> add online_doc "https://erratique.ch/software/uucp/doc/"
    |> add licenses ["ISC"]
    |> add repo "git+https://erratique.ch/repos/uucp.git"
    |> add issues "https://github.com/dbuenzli/uucp/issues"
    |> add description_tags
      ["unicode"; "text"; "character"; "org:erratique"]
    |> add B0_opam.Meta.build
      {|[["ocaml" "pkg/pkg.ml" "build" "--dev-pkg" "%{dev}%"
         "--with-uunf" "%{uunf:installed}%"
         "--with-cmdliner" "%{cmdliner:installed}%" ]]|}
    |> tag B0_opam.tag
    |> add B0_opam.Meta.depopts [ "uunf", ""; "cmdliner", ""]
    |> add B0_opam.Meta.conflicts [ "cmdliner", {|< "1.1.0"|}]
    |> add B0_opam.Meta.depends
      [ "ocaml", {|>= "4.14.0"|};
        "ocamlfind", {|build|};
        "ocamlbuild", {|build|};
        "topkg", {|build & >= "1.0.3"|};
        "b0", {|dev & >= "0.0.5" |};
        "uucd", Fmt.str {|with-test dev & >= "%s" & < "%s"|}
          (String.of_version unicode_version) (String.of_version next_major);
        "uunf", {|with-test|} ]
    |> add B0_opam.Meta.file_addendum
      [ `Field ("post-messages", `L (true, [
            `S "If the build fails with \"ocamlopt.opt got signal and \
                exited\", issue 'ulimit -s unlimited' and retry.";
            `Raw {|{failure & (arch = "ppc64" | arch = "arm64")}|}]))]
  in
  B0_pack.v "default" ~doc:"uucd package" ~meta ~locked:true @@
  B0_unit.list ()
