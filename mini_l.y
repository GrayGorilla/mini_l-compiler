/* Mini-L Language */
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string>
  void yyerror(const char* msg);
  extern int currLine;
  extern int currPos;
  extern FILE* yyin;
  int yylex();
  

  struct program_semval {
      std::string code;
  };
  struct function_semval {
      std::string code;
  };
  struct dec_list_semval {
      std::string code;
  };
  struct sta_loop_semval {
      std::string code;
  };
  struct declaration_semval {
      std::string code;
  };
  struct dec_help_semval {
      std::string code;
  };
  struct array_size_semval {
      std::string code;
  };
  struct statement_semval {
      std::string code;
  };
  struct conditional_semval {
      std::string code;
  };
  struct var_list_semval {
      std::string code;
  };
  struct bool_expr {
      std::string code;
      std::string result_id;
  };
  struct relation_and_expr_semval {
      std::string code;
      std::string result_id;
  };
  struct relation_expr_semval {
      std::string code;
      std::string result_id;
  };
  struct relation_expr_help_semval {
      std::string code;
      std::string result_id;
  };
  struct comp_semval {
      std::string code;
  };
  struct expression_semval {
      std::string code;
      std::string result_id;
  };
  struct expression_help_semval {
      std::string code;
  };
  struct multiplicative_expr_semval {
      std::string code;
      std::string result_id;
  };
  struct multiplicative_expr_help_semval {
      std::string code;
      std::string result_id;
  };
  struct term_semval {
      std::string code;
      std::string result_id;
  };
  struct term_help_semval {
      std::string code;
      std::string result_id;
  };
  struct term_ident_semval {
      std::string code;
      std::string result_id;
  };
  struct var_semval {
      std::string code;
      std::string result_id;
  };
  struct ident_semval {
      std::string code;
      std::string result_id;
  };
  struct number_semval {
      std::string code;
      std::string result_id;
  };
%}

%union {
  int ival;
  char* sval;
}

%error-verbose
%start program
%token NUMBER FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE IDENT SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN 
%type <sval> IDENT
%type <ival> NUMBER
%left L_PAREN R_PAREN
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left MULT DIV MOD
%left ADD SUB
%left LT LTE GT GTE EQ NEQ
%right NOT
%left AND
%left OR
%right ASSIGN


%%

program: { printf("program -> epsilon\n"); }
    | function program { printf("program -> function program\n"); }
;

function: FUNCTION ident SEMICOLON BEGIN_PARAMS dec_list END_PARAMS BEGIN_LOCALS dec_list END_LOCALS BEGIN_BODY sta_loop END_BODY { printf("function -> FUNCTION ident SEMICOLON BEGIN_PARAMS dec_list END_PARAMS BEGIN_LOCALS dec_list END_LOCALS BEGIN_BODY sta_loop END_BODY\n"); }
;

dec_list: { printf("dec_list -> epsilon\n"); }
    | declaration SEMICOLON dec_list { printf("declaration SEMICOLON dec_list\n"); }
;

sta_loop: statement SEMICOLON { printf("sta_loop -> statement SEMICOLON\n"); }
    | statement SEMICOLON sta_loop { printf("sta_loop -> statement SEMICOLON sta_loop\n"); }
;

declaration: dec_help COLON array_size INTEGER { printf("declaration -> dec_help COLON array_size INTEGER\n"); }
;

dec_help: ident { printf("dec_help -> ident\n"); }
    | ident COMMA dec_help { printf("dec_help -> ident comma_indent\n"); }
;

array_size:  { printf("array_size -> epsilon\n"); }
    | ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF { printf("array_size -> ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF\n"); }
;

statement: var ASSIGN expression { printf("statement -> var ASSIGN expression\n"); }
    | IF bool_expr THEN conditional ENDIF { printf("statement -> bool_expr conditional\n"); }
    | WHILE bool_expr BEGINLOOP sta_loop ENDLOOP { printf("statement -> WHILE bool_expr BEGINLOOP sta_loop ENDLOOP\n"); }
    | DO BEGINLOOP sta_loop ENDLOOP WHILE bool_expr { printf("statement -> DO BEGINLOOP sta_loop ENDLOOP WHILE bool_expr\n"); }
    | FOR var ASSIGN number SEMICOLON bool_expr SEMICOLON var ASSIGN expression BEGINLOOP sta_loop ENDLOOP { printf("statement -> FOR var ASSIGN number SEMICOLON bool_expr SEMICOLON var ASSIGN expression BEGINLOOP sta_loop ENDLOOP\n"); }
    | READ var_list { printf("statement -> READ var_list\n"); }
    | WRITE var_list { printf("statement -> WRITE var_list\n"); }
    | CONTINUE { printf("statement -> CONTINUE\n"); }
    | RETURN expression { printf("statement -> RETURN expression\n"); }
;

conditional: sta_loop { printf("conditional -> sta_loop \n"); }
    | sta_loop ELSE sta_loop { printf("conditional -> sta_loop ELSE sta_loop\n"); }
;

var_list: var { printf("var_list -> var\n"); }
    | var COMMA var_list { printf("var_list -> var\n"); }
;

bool_expr: relation_and_expr { printf("bool_expr -> relation_and_expr\n"); }
    | relation_and_expr OR relation_and_expr { printf("bool_expr -> relation_and_expr OR relation_and_expr\n"); }
;

relation_and_expr: relation_expr { printf("relation_and_expr -> relation_expr\n"); }
    | relation_expr AND relation_and_expr { printf("relation_and_expr -> relation_expr AND relation_and_expr\n"); }
;

relation_expr: relation_expr_help { printf("relation_expr -> relation_expr_help\n"); }
    | NOT relation_expr_help { printf("relation_expr -> NOT relation_expr_help\n"); }
;

relation_expr_help: expression comp expression { printf("relation_expr_help -> expression comp expression\n"); }
    | TRUE { printf("relation_expr_help -> TRUE\n"); }
    | FALSE { printf("relation_expr_help -> FALSE\n"); }
    | L_PAREN bool_expr R_PAREN { printf("relation_expr_help -> L_PAREN bool_expr R_PAREN\n"); }
;

comp: EQ { printf("comp -> EQ\n"); }
    | NEQ { printf("comp -> NEQ\n"); }
    | LT { printf("comp -> LT\n"); }
    | GT { printf("comp -> GT\n"); }
    | LTE { printf("comp -> LTE\n"); }
    | GTE { printf("comp -> GTE\n"); }
;

expression: multiplicative_expr { printf("expression -> multiplicative_expr\n"); }
    | multiplicative_expr expression_help { printf("expression -> multiplicative_expr expression_help\n"); }
;

expression_help: ADD multiplicative_expr { printf("expression_help -> ADD multiplicative_expr\n"); }
    | SUB multiplicative_expr { printf("expression_help -> SUB multiplicative_expr\n"); }
    | ADD multiplicative_expr expression_help { printf("expression_help -> ADD multiplicative_expr expression_help\n"); }
    | SUB multiplicative_expr expression_help { printf("expression_help -> SUB multiplicative_expr expression_help\n"); }
;

multiplicative_expr: term { printf("multiplicative_expr -> term\n"); }
    | term multiplicative_expr_help { printf("multiplicative_expr -> term multiplicative_expr_help\n"); }
;

multiplicative_expr_help: MULT term { printf("multiplicative_expr_help -> MULT term\n"); }
    | DIV term { printf("multiplicative_expr_help -> DIV term\n"); }
    | MOD term { printf("multiplicative_expr_help -> MOD term\n"); }
    | MULT term multiplicative_expr_help { printf("multiplicative_expr_help -> MULT term multiplicative_expr_help\n"); }
    | DIV term multiplicative_expr_help { printf("multiplicative_expr_help -> DIV term multiplicative_expr_help\n"); }
    | MOD term multiplicative_expr_help { printf("multiplicative_expr_help -> MOD term multiplicative_expr_help\n"); }
;

term: term_help { printf("term -> term_help\n"); }
    | SUB term_help { printf("term -> SUB term_help\n"); }
    | ident L_PAREN term_ident R_PAREN { printf("term -> L_PAREN term_ident R_PAREN\n"); }
;

term_help: var { printf("term_help -> var\n"); }
    | number { printf("term_help -> number\n"); }
    | L_PAREN expression R_PAREN { printf("term_help -> L_PAREN expression R_PAREN\n"); }
;

term_ident:  { printf("term_indent -> epsilon\n"); }
    | expression { printf("term_ident -> expression\n"); }
    | expression COMMA term_ident { printf("term_ident -> expression COMMA term_ident\n"); }
;

var: ident { printf("var -> ident\n"); }
    | ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET { printf("var -> ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n"); }
;

ident: IDENT { printf("ident -> IDENT %s\n", $1); }
;

number: NUMBER { printf("number -> NUMBER %d\n", $1); }
;

%%


int main(int argc, char** argv) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
      printf("syntax: %s filename\n", argv[0]);
    }
  }
  yyparse();  // Calls yylex() for tokens
  return 0;
}

void yyerror(const char* msg) {
  printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}
