
/* Syntax analyzer for mini-Turtle */

%{
  open Ast

  let neg e = Ebinop (Sub, Econst 0, e)
%}

/* Token declaration */

%token <int> CST
%token <string> IDENT
%token COMMA
%token DEF
%token PLUS MINUS TIMES DIV
%token LPAREN RPAREN
%token BEGIN END
%token PENUP PENDOWN FORWARD TURNLEFT TURNRIGHT
%token IF ELSE REPEAT
%token COLOR BLACK WHITE RED GREEN BLUE
%token EOF

/* Priorities et associativity laws for tokens */
%left MINUS PLUS
%left TIMES DIV
%nonassoc uminus
%nonassoc IF
%nonassoc ELSE

/* Entry point of the grammar */
%start prog

/* The Type of the value returned by the syntax analysis */
%type <Ast.program> prog

%%

/* Grammar rules */

prog:
  defs = def*
  main = stmt*
  EOF
    { { defs = defs;
        main = Sblock main; } }
;

def:
| DEF f = IDENT
  LPAREN formals = separated_list(COMMA, IDENT) RPAREN body = stmt
    { { name = f;
        formals = formals;
        body = body } }
;

stmt:
| PENUP
    { Spenup }
| PENDOWN
    { Spendown }
| FORWARD e = expr
    { Sforward e }
| TURNLEFT e = expr
    { Sturn e }
| TURNRIGHT e = expr
    { Sturn (neg e) }
| COLOR c = color
              { Scolor c }
| id = IDENT LPAREN actuals = separated_list(COMMA, expr) RPAREN
    { Scall (id, actuals) }
| IF e = expr s = stmt
    { Sif (e, s, Sblock []) }
| IF e = expr s1 = stmt ELSE s2 = stmt
    { Sif (e, s1, s2) }
| REPEAT e = expr b = stmt
    { Srepeat (e, b) }
| BEGIN is = stmt* END
    { Sblock is }
;

expr:
| c = CST                        { Econst c }
| e1 = expr o = op e2 = expr     { Ebinop (o, e1, e2) }
| id = IDENT                     { Evar id }
| MINUS e = expr %prec uminus    { neg e }
| LPAREN e = expr RPAREN         { e }
;

%inline op:
| PLUS  { Add }
| MINUS { Sub }
| TIMES { Mul }
| DIV   { Div }
;

color:
| BLACK { Turtle.black }
| WHITE { Turtle.white }
| RED   { Turtle.red   }
| GREEN { Turtle.green }
| BLUE  { Turtle.blue  }
;