(* Copyright (C) 2021  Petter A. Urkedal <paurkedal@gmail.com>
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version, with the LGPL-3.0 Linking Exception.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * and the LGPL-3.0 Linking Exception along with this library.  If not, see
 * <http://www.gnu.org/licenses/> and <https://spdx.org>, respectively.
 *)

module type Alcotest = sig
  include Alcotest_engine.V1.Cli.S

  val test_case :
    string -> Alcotest.speed_level -> ('a -> return) -> 'a test_case

  val test_case_sync :
    string -> Alcotest.speed_level -> ('a -> unit) -> 'a test_case

  val run_with_args_dependency :
    ?argv: string array -> string ->
    'a Cmdliner.Term.t -> ('a -> unit test list) -> return
end

module type Ground = sig
  type +'a future

  val (>>=) : 'a future -> ('a -> 'b future) -> 'b future
  val (>|=) : 'a future -> ('a -> 'b) -> 'b future
  val return : 'a -> 'a future
  val or_fail : ('a, [< Caqti_error.t]) result -> 'a future

  module Caqti_sys : Caqti_connect_sig.S with type 'a future := 'a future

  module Alcotest : Alcotest with type return = unit future

end
