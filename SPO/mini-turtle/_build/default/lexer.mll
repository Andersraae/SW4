
(* Analyseur lexical pour mini-Turtle *)

{
  open Lexing
  open Parser

  (* exception à lever pour signaler une erreur lexicale *)
  exception Lexing_error of string

  (* note : penser à appeler la fonction Lexing.new_line
     à chaque retour chariot (caractère '\n') *)

}

(* Complete the file lexer.mll to ignore blanks and comments and to return the token EOF when the end of input is reached. 
The command make should be opening an empty window, since file test.logo only contains comments at this point. *)


rule token = parse
 | [' ' '\t' '\r' '\n'] { token lexbuf }