/* Mini-L Language */
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string>
  #include <sstream>
  #include <iostream>
  #include <utility>
  #include <queue>
  using namespace std;


  class TempManager {
    private:
        int nextTempID;
    public:
        TempManager() : nextTempID(0) {}
        int tempGen();
        int getTopTempID();
        string getTemp(int id);
  };

  class LabelManager {
    private:
        int nextLabelID;
    public:
        LabelManager() : nextLabelID(0) {}
        int labelGen();
        std::string getLabel(int id);
  };


  extern int currLine;
  extern int currPos;
  extern FILE* yyin;
  const int NOT_ARRAY = -1;
  TempManager* tm;
  LabelManager* lm;
  int yylex();
  void yyerror(const char* msg);

  struct program_struct {
      string code;
  };
  struct function_struct {
      string code;
  };
  struct dec_list_struct {
      string code;
  };
  struct sta_loop_struct {
      string code;
  };
  struct declaration_struct {
      string code;
  };
  struct dec_help_struct {
      string code;
      queue<string> identList;
  };
  struct array_size_struct {
      string code;
  };
  struct statement_struct {
      string code;
  };
  struct conditional_struct {
      string code;
  };
  struct var_list_struct {
      string code;
      queue<pair<string, int>> varTypes;
  };
  struct bool_expr {
      string code;
      int result_id;
  };
  struct relation_and_expr_struct {
      string code;
      int result_id;
  };
  struct relation_expr_struct {
      string code;
      int result_id;
  };
  struct relation_expr_help_struct {
      string code;
      int result_id;
  };
  struct comp_struct {
      string comp;
  };
  struct expression_struct {
      string code;
      string number;
      int result_id;
  };
  struct multiplicative_expr_struct {
      string code;
      string number;
      int result_id;
  };
  struct term_struct {
      string code;
      string number;
      int result_id;
  };
  struct term_help_struct {
      string code;
      string number;
      int result_id;
  };
  struct term_ident_struct {
      string code;
  };
  struct var_struct {
      string code;
      string ident;
      int result_id;
      int index_id;
  };
  struct ident_struct {
      string ident;
  };
  struct number_struct {
      string code;
      string number;
      int result_id;
  };
%}

%union {
  int ival;
  char* sval;
  struct program_struct *program_semval;
  struct function_struct *function_semval;
  struct dec_list_struct *dec_list_semval;
  struct sta_loop_struct *sta_loop_semval;
  struct declaration_struct *declaration_semval;
  struct dec_help_struct *dec_help_semval;
  struct array_size_struct *array_size_semval;
  struct statement_struct *statement_semval;
  struct conditional_struct *conditional_semval;
  struct var_list_struct *var_list_semval;
  struct bool_expr_struct *bool_expr_semval;
  struct relation_and_expr_struct *relation_and_expr_semval;
  struct relation_expr_struct *relation_expr_semval;
  struct relation_expr_help_struct *relation_expr_help_semval;
  struct comp_struct *comp_semval;
  struct expression_struct *expression_semval;
  struct multiplicative_expr_struct *multiplicative_expr_semval;
  struct term_struct *term_semval;
  struct term_help_struct *term_help_semval;
  struct term_ident_struct *term_ident_semval;
  struct var_struct *var_semval;
  struct ident_struct *ident_semval;
  struct number_struct *number_semval;
}

%error-verbose
%start program
%token NUMBER FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE IDENT SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN 
%type <sval> IDENT
%type <ival> NUMBER
%type <program_semval> program
%type <function_semval> function
%type <dec_list_semval> dec_list
%type <sta_loop_semval> sta_loop
%type <declaration_semval> declaration
%type <dec_help_semval> dec_help
%type <array_size_semval> array_size
%type <statement_semval> statement
%type <conditional_semval> conditional
%type <var_list_semval> var_list
%type <bool_expr_semval> bool_expr
%type <relation_and_expr_semval> relation_and_expr
%type <relation_expr_semval> relation_expr
%type <relation_expr_help_semval> relation_expr_help
%type <comp_semval> comp
%type <expression_semval> expression
%type <multiplicative_expr_semval> multiplicative_expr
%type <term_semval> term
%type <term_help_semval> term_help
%type <term_ident_semval> term_ident
%type <var_semval> var
%type <ident_semval> ident
%type <number_semval> number
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

program: 
    { 
        printf("program -> epsilon\n"); 
        $$ = new program_struct();
        $$->code = "";
    }
| 
    function program { 
        printf("program -> function program\n"); 
        $$ = new program_struct();
        ostringstream oss;

        oss << $1->code << $2->code;
        $$->code = oss.str();
        delete $1;
        delete $2;

        cout << "\n-----------------------\n" << endl;
        cout << $$->code << endl;
        delete $$;
    }
;

function: 
    FUNCTION ident SEMICOLON BEGIN_PARAMS dec_list END_PARAMS BEGIN_LOCALS dec_list END_LOCALS BEGIN_BODY sta_loop END_BODY { 
        printf("function -> FUNCTION ident SEMICOLON BEGIN_PARAMS dec_list END_PARAMS BEGIN_LOCALS dec_list END_LOCALS BEGIN_BODY sta_loop END_BODY\n"); 
        $$ = new function_struct();
        ostringstream oss;

        oss << "func " << $2->ident << endl;
        oss << $5->code << $8->code << $11->code;
        oss << "endfunc\n" << endl;

        $$->code = oss.str();
        delete $2;
        delete $5;
        delete $8;
        delete $11;
    }
;

dec_list: 
    { 
        printf("dec_list -> epsilon\n"); 
        $$ = new dec_list_struct();
        $$->code = "";

    }
| 
    declaration SEMICOLON dec_list { 
        printf("declaration SEMICOLON dec_list\n"); 
        $$ = new dec_list_struct();
        ostringstream oss;

        oss << $1->code << $3->code;
        $$->code = oss.str();
        delete $1;
        delete $3;
    }
;

sta_loop: 
    statement SEMICOLON { 
        printf("sta_loop -> statement SEMICOLON\n"); 
        $$ = new sta_loop_struct();
        ostringstream oss;

        $$->code = $1->code;
        delete $1;
    }
| 
    statement SEMICOLON sta_loop { 
        printf("sta_loop -> statement SEMICOLON sta_loop\n");
        $$ = new sta_loop_struct();
        ostringstream oss;

        oss << $1->code << $3->code;
        $$->code = oss.str(); 
        delete $1;
        delete $3;
    }
;

declaration: 
    dec_help COLON array_size INTEGER { 
        printf("declaration -> dec_help COLON array_size INTEGER\n"); 
        $$ = new declaration_struct();
        ostringstream oss;
        string identCode;

        // Non-array declaration
        if ($3->code.empty()) {
            while (! $1->identList.empty()) {
                identCode = $1->identList.front();
                $1->identList.pop();
                oss << ". " << identCode << endl;
            }
        // Array declaration
        } else {
            while (! $1->identList.empty()) {
                identCode = $1->identList.front();
                $1->identList.pop();
                oss << ".[] " << identCode << $3->code << endl;
            }
        }
        $$->code = oss.str();
        delete $1;
        delete $3;
    }
;

dec_help: 
    ident { 
        printf("dec_help -> ident\n");
        $$ = new dec_help_struct();
        string identCode = $1->ident;
        
        $$->identList.push(identCode);
        delete $1;
    }
| 
    ident COMMA dec_help { 
        printf("dec_help -> ident comma_indent\n"); 
        $$ = new dec_help_struct();
        string identCode = $1->ident;

        $$->identList.push(identCode);
        while (! $3->identList.empty()) {
            identCode = $3->identList.front();
            $3->identList.pop();
            $$->identList.push(identCode);
        }
        delete $1;
        delete $3;
    }
;

array_size:  
    { 
        printf("array_size -> epsilon\n"); 
        $$ = new array_size_struct();
        $$->code = "";
    }
| 
    ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF { 
        printf("array_size -> ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF\n"); 
        $$ = new array_size_struct();
        ostringstream oss;

        oss << ", " << $3->number;
        $$->code = oss.str();
        delete $3;
    }
;

statement: 
    var ASSIGN expression { 
        printf("statement -> var ASSIGN expression\n"); 
        $$ = new statement_struct();
        ostringstream oss;
        const int exprResultID = $3->result_id;
        const int indexID = $1->index_id;

        oss << $1->code << $3->code;
        if (indexID == NOT_ARRAY) {
            oss << "= " << $1->ident << ", " << tm->getTemp(exprResultID) << endl;
        } else {
            oss << "[]= " << $1->ident << ", " << tm->getTemp(indexID) << ", " << tm->getTemp(exprResultID) << endl;
        }
        $$->code = oss.str();
        delete $1;
        delete $3;
    }
| 
    IF bool_expr THEN conditional ENDIF { printf("statement -> bool_expr conditional\n"); }
| 
    WHILE bool_expr BEGINLOOP sta_loop ENDLOOP { printf("statement -> WHILE bool_expr BEGINLOOP sta_loop ENDLOOP\n"); }
| 
    DO BEGINLOOP sta_loop ENDLOOP WHILE bool_expr { printf("statement -> DO BEGINLOOP sta_loop ENDLOOP WHILE bool_expr\n"); }
| 
    FOR var ASSIGN number SEMICOLON bool_expr SEMICOLON var ASSIGN expression BEGINLOOP sta_loop ENDLOOP { printf("statement -> FOR var ASSIGN number SEMICOLON bool_expr SEMICOLON var ASSIGN expression BEGINLOOP sta_loop ENDLOOP\n"); }
| 
    READ var_list { 
        printf("statement -> READ var_list\n"); 
        $$ = new statement_struct();
        ostringstream oss;
        pair<string, int> vType;
        string index;
        oss << $2->code;

        // Pops all variable types off the queue and puts into MIL code
        while (! $2->varTypes.empty()) {
            vType = $2->varTypes.front();
            $2->varTypes.pop();
            index = tm->getTemp(vType.second);
            if (vType.second == NOT_ARRAY) {
                // Non-Array Var
                oss << ".< " << vType.first << endl;
            } else {
                // Array Var
                oss << ".[]< " << vType.first << ", " << index << endl;
            }
        }
        $$->code = oss.str();
        delete $2;
    }
| 
    WRITE var_list { 
        printf("statement -> WRITE var_list\n"); 
        $$ = new statement_struct();
        ostringstream oss;
        pair<string, int> vType;
        string index;
        oss << $2->code;

        // Pops all variable types off the queue and puts into MIL code
        while (! $2->varTypes.empty()) {
            vType = $2->varTypes.front();
            $2->varTypes.pop();
            index = tm->getTemp(vType.second);
            if (vType.second == NOT_ARRAY) {
                // Non-Array Var
                oss << ".> " << vType.first << endl;
            } else {
                // Array Var
                oss << ".[]> " << vType.first << ", " << index << endl;
            }
        }
        $$->code = oss.str();
        delete $2;
    }
    | CONTINUE { printf("statement -> CONTINUE\n"); }
    | RETURN expression { printf("statement -> RETURN expression\n"); }
;

conditional: sta_loop { printf("conditional -> sta_loop \n"); }
    | sta_loop ELSE sta_loop { printf("conditional -> sta_loop ELSE sta_loop\n"); }
;

var_list: 
    var { 
        printf("var_list -> var\n"); 
        $$ = new var_list_struct();
        pair<string, int> vType($1->ident, $1->index_id);
        
        $$->code = $1->code;
        $$->varTypes.push(vType);
        delete $1;
    }
| 
    var COMMA var_list { 
        printf("var_list -> var COMMA var_list\n");
        $$ = new var_list_struct();
        ostringstream oss;
        pair<string, int> vType;

        oss << $1->code << $3->code;
        $$->code = oss.str();

        vType = make_pair($1->ident, $1->index_id);
        $$->varTypes.push(vType);
        while (! $3->varTypes.empty()) {
            vType = $3->varTypes.front();
            $3->varTypes.pop();
            $$->varTypes.push(vType);
        }
        delete $1; 
        delete $3;
    }
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

relation_expr_help: 
    expression comp expression { 
        printf("relation_expr_help -> expression comp expression\n"); 
        $$ = new relation_expr_help_struct();
    }
| 
    TRUE { 
        printf("relation_expr_help -> TRUE\n"); 
        $$ = new relation_expr_help_struct();
        // Write code here
    }
| 
    FALSE { 
        printf("relation_expr_help -> FALSE\n"); 
        $$ = new relation_expr_help_struct();
        // Write code here
    }
| 
    L_PAREN bool_expr R_PAREN { 
        printf("relation_expr_help -> L_PAREN bool_expr R_PAREN\n"); 
        $$ = new relation_expr_help_struct();
        // Write code here
    }
;

comp: 
    EQ { 
        printf("comp -> EQ\n");
        $$ = new comp_struct();
        $$->comp = "=="; 
    }
| 
    NEQ { 
        printf("comp -> NEQ\n");
        $$ = new comp_struct();
        $$->comp = "!="; 
    }
| 
    LT { 
        printf("comp -> LT\n");
        $$ = new comp_struct();
        $$->comp = "<"; 
    }
| 
    GT { 
        printf("comp -> GT\n");
        $$ = new comp_struct();
        $$->comp = ">"; 
    }
| 
    LTE { 
        printf("comp -> LTE\n");
        $$ = new comp_struct();
        $$->comp = ""; 
    }
| 
    GTE { 
        printf("comp -> GTE\n");
        $$ = new comp_struct();
        $$->comp = ""; 
    }
;

expression: 
    multiplicative_expr { 
        printf("expression -> multiplicative_expr\n"); 
        $$ = new expression_struct();

        $$->code = $1->code;
        $$->result_id = $1->result_id;
        $$->number = $1->number; 
        delete $1;
    }
| 
    expression ADD multiplicative_expr { 
        printf("expression -> expression ADD multiplicative_expr\n"); 
        $$ = new expression_struct();
        ostringstream oss;
        
        $$->result_id = tm->tempGen();
        oss << $1->code << $3->code;
        oss << ". " << tm->getTemp($$->result_id) << endl; 
        oss << "+ " << tm->getTemp($$->result_id) << ", " << tm->getTemp($1->result_id) << ", " << tm->getTemp($3->result_id) << endl;
        
        $$->code = oss.str();
        $$->number = $1->number; 
        delete $1;
        delete $3;
    }
| 
    expression SUB multiplicative_expr { 
        printf("expression -> expression SUB multiplicative_expr\n"); 
        $$ = new expression_struct();
        ostringstream oss;

        $$->result_id = tm->tempGen();
        oss << $1->code << $3->code;
        oss << ". " << tm->getTemp($$->result_id) << endl; 
        oss << "- " << tm->getTemp($$->result_id) << ", " << tm->getTemp($1->result_id) << ", " << tm->getTemp($3->result_id) << endl;

        $$->code = oss.str();
        $$->number = $1->number; 
        delete $1;
        delete $3;
    }
;

multiplicative_expr: 
    term { 
        printf("multiplicative_expr -> term\n"); 
        $$ = new multiplicative_expr_struct();
        
        $$->code = $1->code;
        $$->result_id = $1->result_id;
        $$->number = $1->number; 
        delete $1;
    }
| 
    multiplicative_expr DIV term { 
        printf("multiplicative_expr -> term DIV multiplicative_expr\n"); 
        $$ = new multiplicative_expr_struct();
        ostringstream oss;

        $$->result_id = tm->tempGen();
        oss << $1->code << $3->code;
        oss << ". " << tm->getTemp($$->result_id) << endl; 
        oss << "/ " << tm->getTemp($$->result_id) << ", " << tm->getTemp($1->result_id) << ", " << tm->getTemp($3->result_id) << endl;
        
        $$->code = oss.str();
        $$->number = $1->number; 
        delete $1;
        delete $3;

    }
| 
    multiplicative_expr MOD term { 
        printf("multiplicative_expr -> term MOD multiplicative_expr\n"); 
        $$ = new multiplicative_expr_struct();
        ostringstream oss;

        $$->result_id = tm->tempGen();
        oss << $1->code << $3->code;
        oss << ". " << tm->getTemp($$->result_id) << endl; 
        oss << "% " << tm->getTemp($$->result_id) << ", " << tm->getTemp($1->result_id) << ", " << tm->getTemp($3->result_id) << endl;
        
        $$->code = oss.str();
        $$->number = $1->number; 
        delete $1;
        delete $3;        
    }
| 
    multiplicative_expr MULT term { 
        printf("multiplicative_expr -> term MULT multiplicative_expr\n"); 
        $$ = new multiplicative_expr_struct();
        ostringstream oss;

        $$->result_id = tm->tempGen();
        oss << $1->code << $3->code;
        oss << ". " << tm->getTemp($$->result_id) << endl; 
        oss << "* " << tm->getTemp($$->result_id) << ", " << tm->getTemp($1->result_id) << ", " << tm->getTemp($3->result_id) << endl;
        
        $$->code = oss.str();
        $$->number = $1->number; 
        delete $1;
        delete $3;
    }
;

term: 
    term_help { 
        printf("term -> term_help\n"); 
        $$ = new term_struct();

        $$->result_id = $1->result_id;
        $$->code = $1->code;
        $$->number = $1->number; 
        delete $1;
    }
| 
    SUB term_help { printf("term -> SUB term_help\n"); }
| 
    ident L_PAREN term_ident R_PAREN { printf("term -> L_PAREN term_ident R_PAREN\n"); }
|
    ident L_PAREN R_PAREN { printf("term -> L_PAREN R_PAREN\n"); }
;

term_help: 
    var { 
        printf("term_help -> var\n"); 
        $$ = new term_help_struct();

        $$->code = $1->code;
        $$->result_id = $1->result_id;
        $$->number = "";
        delete $1;
    }
| 
    number { 
        printf("term_help -> number\n"); 
        $$ = new term_help_struct();

        $$->code = $1->code;
        $$->result_id = $1->result_id;
        $$->number = $1->number;
        delete $1;
    }
| 
    L_PAREN expression R_PAREN { 
        printf("term_help -> L_PAREN expression R_PAREN\n"); 
        $$ = new term_help_struct();

        $$->code = $2->code;
        $$->result_id = $2->result_id;
        $$->number = "";
        delete $2;
    }
;

term_ident:  
    expression { printf("term_ident -> expression\n"); }
| 
    expression COMMA term_ident { printf("term_ident -> expression COMMA term_ident\n"); }
;

var: 
    ident { 
        printf("var -> ident\n"); 
        $$ = new var_struct();
        ostringstream oss;

        $$->result_id = tm->tempGen();
        oss << ". " << tm->getTemp($$->result_id) << endl;
        oss << "= " << tm->getTemp($$->result_id) << ", " << $1->ident << endl;
        
        $$->code = oss.str();
        $$->ident = $1->ident;
        $$->index_id = NOT_ARRAY;
        delete $1;
    }
| 
    ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET { 
        printf("var -> ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n"); 
        $$ = new var_struct();
        ostringstream oss;
        const int exprResultID = $3->result_id;

        $$->result_id = tm->tempGen();
        oss << $3->code;
        oss << ". " << tm->getTemp($$->result_id) << endl;
        oss << "=[] " << tm->getTemp($$->result_id) << ", " << $1->ident << ", " << tm->getTemp(exprResultID) << endl;
        
        $$->code = oss.str();
        $$->ident = $1->ident;
        $$->index_id = exprResultID;
        delete $1;
        delete $3;
    }
;

ident: 
    IDENT { 
        printf("ident -> IDENT %s\n", $1); 
        $$ = new ident_struct();
        $$->ident = $1;
    }
;

number: 
    NUMBER { 
        printf("number -> NUMBER %d\n", $1); 
        $$ = new number_struct();
        ostringstream oss;
        stringstream ss;

        $$->result_id = tm->tempGen();
        oss << ". " << tm->getTemp($$->result_id) << endl;
        oss << "= " << tm->getTemp($$->result_id) << ", " << $1 << endl;
        ss << $1;

        $$->code = oss.str();
        $$->number = ss.str();
    }
;

%%


int main(int argc, char** argv) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
      printf("syntax: %s filename\n", argv[0]);
    }
  }
  tm = new TempManager();
  yyparse();  // Calls yylex() for tokens
  delete tm;
  return 0;
}

void yyerror(const char* msg) {
  printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}

/* Temp Manager Methods */

int TempManager::tempGen() {
    return nextTempID++;
}

string TempManager::getTemp(int id) {
    stringstream ss;
    ss << id;
    return "__temp__" + ss.str();
}

/* Label Manager Methods */

int LabelManager::labelGen() {
    return nextLabelID++;
}

std::string LabelManager::getLabel(int id) {
    std::stringstream ss;
    ss << id;
    return "__label__" + ss.str();
}

