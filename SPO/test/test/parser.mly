%token PLUS EOF LESS
%token <int> INT
%start main
%start expr
%type <Ast.expr> main
%type <Ast.expr> expr

%%

main:
  | stmt EOF { $1 }
  ;

expr:
  | INT { Int $1 }
  | expr PLUS expr { Add($1, $3) }
  // | expr LESS expr { Less($1, $3) }
  ;

stmt:
  | expr { $1 }
  ;

