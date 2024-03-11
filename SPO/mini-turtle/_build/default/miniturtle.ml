
(* Main file of the mini-Turtle interpreter *)

open Format
open Lexing

(* Option de compilation, to stop just after parsing. *)
let parse_only = ref false

(* Names of the source and output files. *)
let ifile = ref ""
let ofile = ref ""

let set_file f s = f := s

(* Compiler options to print with --help option. *)
let options =
  ["--parse-only", Arg.Set parse_only,
   "  To only parse the source file"]

let usage = "usage: mini-turtle [option] file.logo"

(* To localize a error (e.g. lexing or syntax error) showing line and column
   in the source file *)
let localisation pos =
  let l = pos.pos_lnum in
  let c = pos.pos_cnum - pos.pos_bol + 1 in
  eprintf "File \"%s\", line %d, characters %d-%d:\n" !ifile l (c-1) c

let () =
  (* Parsing the command line *)
  Arg.parse options (set_file ifile) usage;

  (* Check that the name of the source file was given. *)
  if !ifile="" then begin eprintf "No file to compile\n@?"; exit 1 end;

  (* And that this file must have extension .logo *)
  if not (Filename.check_suffix !ifile ".logo") then begin
    eprintf "File must have extension .logo\n@?";
    Arg.usage options usage;
    exit 1
  end;

  (* Opening the input channel for the source file. *)
  let f = open_in !ifile in

  (* Creating a lexical buffer to recognize tokens and perform lexical analysis. *)
  let buf = Lexing.from_channel f in

  try
    (* Parsing: the function Parser.prog transforms the lexical buffer
       into an abstract syntax tree if no lexical or syntax errors has been
       detected during the parsing phase.
       The function Lexer.token is used by Parser.prog to get the next token
       from the lexer. *)
    let p = Parser.prog Lexer.token buf in
    close_in f;

    (* On s'arrÃªte ici si on ne veut faire que le parsing *)
    if !parse_only then exit 0;

    Interp.prog p
  with
    | Lexer.Lexing_error c ->
	(* Lexical error. We get the absolute position in the input file
           and we convert it into the line number. *)
	localisation (Lexing.lexeme_start_p buf);
	eprintf "Lexical error: %s@." c;
	exit 1
    | Parser.Error ->
	(* Syntax error. Same for the localization. *)
	localisation (Lexing.lexeme_start_p buf);
	eprintf "Syntax error@.";
	exit 1
    | Interp.Error s->
	(* Interpreter error. *)
	eprintf "Erreur : %s@." s;
	exit 1