(*
 * Copyright (c) 2013 Thomas Gazagnaire <thomas@gazagnaire.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

open Lwt
open Test_common

let test_db = "test_db_git"

let init_disk () =
  if Filename.basename (Sys.getcwd ()) <> "lib_test" then
    failwith "The Git test should be run in the lib_test/ directory."
  else if Sys.file_exists test_db then
    Git_unix.FS.create ~root:test_db () >>= fun t ->
    Git_unix.FS.clear t
  else
    return_unit

let suite k =
  {
    name   = "GIT" ^ string_of_kind k;
    kind   = k;
    init   = init_disk;
    clean  = none;
    store  = git_store k;
    config = Irmin_git.config ~root:test_db ~head:"test" ~bare:true ()
  }