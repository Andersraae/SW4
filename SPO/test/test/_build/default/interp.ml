open Lexing
open Printf
open Parser
open Ast

let rec interpret = function
  | Int n -> n
  | Add (e1, e2) -> interpret e1 + interpret e2
  (* | Less (e1, e2) -> interpret e1 < interpret e2 *)

let rec interpret_to_string = function
  | Int n -> string_of_int n
  | Add (e1, e2) -> string_of_int (interpret (Add (e1, e2)))
  (* | Less (e1, e2) -> string_of_bool (interpret Less (e1, e2)) *)

let _ =
  try
    while true do
      printf "Enter a sentence: %!";
      let input = input_line stdin in
      let lexbuf = Lexing.from_string input in
      let ast = Parser.main Lexer.token lexbuf in
      let result = interpret_to_string ast in
      printf "Result: %s\n" result;
    done
  with End_of_file -> ()
