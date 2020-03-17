/* Mini-L Language */
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string>
  #include <sstream>
  #include <iostream>
  #include <utility>
  #include <queue>
  #include <vector>
  using namespace std;


  class TempManager {
    private:
        int nextTempID;
    public:
        TempManager() : nextTempID(0) {}
        int tempGen();
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
      vector<int> continue_ids;
  };
  struct declaration_struct {
      string code;
  };
  struct dec_help_struct {
      string code;
      queue<string> identList;
  };
  struct array_size_struct {
      string array_size;
  };
  struct statement_struct {
      string code;
      vector<int> continue_ids;
  };
  struct conditional_struct {
      string code;
      int true_id;
      int false_id;
      vector<int> continue_ids;
  };
  struct var_list_struct {
      string code;
      queue<pair<string, int>> varTypes;
  };
  struct bool_expr_struct {
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
  struct function_parameters_struct {
      string code;
      vector<int> parameter_ids;
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
  struct function_parameters_struct *function_parameters_semval;
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
%type <function_parameters_semval> function_parameters
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
        $$ = new program_struct();
        $$->code = "";
    }
| 
    function program { 
        $$ = new program_struct();
        ostringstream oss;

        oss << $1->code << $2->code;
        $$->code = oss.str();
        delete $1;
        delete $2;

        cout << $$->code << endl;
        delete $$;
    }
;

function: 
    FUNCTION ident SEMICOLON BEGIN_PARAMS dec_list END_PARAMS BEGIN_LOCALS dec_list END_LOCALS BEGIN_BODY sta_loop END_BODY { 
        $$ = new function_struct();
        ostringstream oss;
        vector<int> continueIDs = $11->continue_ids;   

        if (! continueIDs.empty()) {
            cerr << "Error: 'continue' statements cannot be used outside of a loop." << endl;
            exit(1);
        }
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
        $$ = new dec_list_struct();
        $$->code = "";
    }
| 
    declaration SEMICOLON dec_list { 
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
        $$ = new sta_loop_struct();
        $$->continue_ids = $1->continue_ids;
        $$->code = $1->code;
        delete $1;
    }
| 
    statement SEMICOLON sta_loop { 
        $$ = new sta_loop_struct();
        ostringstream oss;
        vector<int> staLoopContinueIDs = $3->continue_ids;
        oss << $1->code << $3->code;

        // Get continueIDs from all statements
        $$->continue_ids = $1->continue_ids;
        for (int i = 0; i < staLoopContinueIDs.size(); i++) {
            $$->continue_ids.push_back(staLoopContinueIDs.at(i));
        }
        $$->code = oss.str(); 
        delete $1;
        delete $3;
    }
;

declaration: 
    dec_help COLON array_size INTEGER { 
        $$ = new declaration_struct();
        ostringstream oss;
        string identCode;

        // Non-array declaration
        if ($3->array_size.empty()) {
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
                oss << ".[] " << identCode << $3->array_size << endl;
            }
        }
        $$->code = oss.str();
        delete $1;
        delete $3;
    }
;

dec_help: 
    ident { 
        $$ = new dec_help_struct();
        string identCode = $1->ident;
        
        // Put identifier into a queue
        $$->identList.push(identCode);
        delete $1;
    }
| 
    ident COMMA dec_help { 
        $$ = new dec_help_struct();
        string identCode = $1->ident;

        // Put all identifiers into a queue
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
        $$ = new array_size_struct();
        $$->array_size = "";
    }
| 
    ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF { 
        $$ = new array_size_struct();
        ostringstream oss;

        oss << ", " << $3->number;
        $$->array_size = oss.str();
        delete $3;
    }
;

statement: 
    var ASSIGN expression { 
        $$ = new statement_struct();
        ostringstream oss;
        int exprResultID = $3->result_id;
        int indexID = $1->index_id;

        oss << $1->code << $3->code;
        if (indexID == NOT_ARRAY) {
            // Non-array var
            oss << "= " << $1->ident << ", " << tm->getTemp(exprResultID) << endl;
        } else {
            // Array var
            oss << "[]= " << $1->ident << ", " << tm->getTemp(indexID) << ", " << tm->getTemp(exprResultID) << endl;
        }
        $$->code = oss.str();
        delete $1;
        delete $3;
    }
| 
    IF bool_expr THEN conditional ENDIF { 
        $$ = new statement_struct();
        ostringstream oss;

        int trueID = $4->true_id;
        int falseID = $4->false_id;
        int boolExprResultID = $2->result_id;

        string trueLabel = lm->getLabel(trueID);
        string falseLabel = lm->getLabel(falseID);

        // Check validity of if statement
        oss << $2->code;
        oss << "?:= " << trueLabel << ", " << tm->getTemp(boolExprResultID) << endl;
        oss << ":= " << falseLabel << endl;

        oss << $4->code;
        $$->continue_ids = $4->continue_ids;
        $$->code = oss.str();
        delete $2;
        delete $4;
    }
| 
    WHILE bool_expr BEGINLOOP sta_loop ENDLOOP { 
        $$ = new statement_struct();
        ostringstream oss;

        int loopID = lm->labelGen();
        int trueID = lm->labelGen();
        int falseID = lm->labelGen();
        int boolExprResultID = $2->result_id;

        string loopLabel = lm->getLabel(loopID);
        string trueLabel = lm->getLabel(trueID);
        string falseLabel = lm->getLabel(falseID);
        vector<int> continueIDs = $4->continue_ids;

        // Initialize loop
        oss << ": " << loopLabel << endl;

        // Check loop validity
        oss << $2->code;
        oss << "?:= " << trueLabel << ", " << tm->getTemp(boolExprResultID) << endl;
        oss << ":= " << falseLabel << endl;

        // Loop body
        oss << ": " << trueLabel << endl;
        oss << $4->code;

        // Continue labels (if exists)
        for (int i = 0; i < continueIDs.size(); i++) {
            oss << ": " << lm->getLabel(continueIDs.at(i)) << endl;
        }
        // Loop back
        oss << ":= " << loopLabel << endl;
        oss << ": " << falseLabel << endl;

        $$->code = oss.str();
        delete $2;
        delete $4;
    }
| 
    DO BEGINLOOP sta_loop ENDLOOP WHILE bool_expr { 
        $$ = new statement_struct();
        ostringstream oss;

        int loopID = lm->labelGen();
        int boolExprResultID = $6->result_id;
        string loopLabel = lm->getLabel(loopID);
        vector<int> continueIDs = $3->continue_ids;

        // Loop body (sta_loop before bool_expr code)
        oss << ": " << loopLabel << endl;
        oss << $3->code;

        // Continue labels (if exists)
        for (int i = 0; i < continueIDs.size(); i++) {
            oss << ": " << lm->getLabel(continueIDs.at(i)) << endl;
        }
        oss << $6->code;

        // Check loop validity, then loop back if applicable
        oss << "?:= " << loopLabel << ", " << tm->getTemp(boolExprResultID) << endl;
        $$->code = oss.str();
        delete $3;
        delete $6;
    }
| 
    FOR var ASSIGN number SEMICOLON bool_expr SEMICOLON var ASSIGN expression BEGINLOOP sta_loop ENDLOOP { 
        $$ = new statement_struct();
        ostringstream oss;

        int loopID = lm->labelGen();
        int trueID = lm->labelGen();
        int falseID = lm->labelGen();
        int boolExprResultID = $6->result_id;
        int exprResultID = $10->result_id;

        string loopLabel = lm->getLabel(loopID);
        string trueLabel = lm->getLabel(trueID);
        string falseLabel = lm->getLabel(falseID);
        vector<int> continueIDs = $12->continue_ids;

        // Initialize loop
        oss << "= " << $2->ident << ", " << $4->number << endl;
        oss << ": " << loopLabel << endl;
        
        // Check loop validity
        oss << $6->code;
        oss << "?:= " << trueLabel << ", " << tm->getTemp(boolExprResultID) << endl;
        oss << ":= " << falseLabel << endl;

        // Loop body
        oss << ": " << trueLabel << endl;
        oss << $12->code << $10->code;

        // Continue labels (if exists)
        for (int i = 0; i < continueIDs.size(); i++) {
            oss << ": " << lm->getLabel(continueIDs.at(i)) << endl;
        }
        // Increment/Decrement, then loop back
        oss << "= " << $8->ident << ", " << tm->getTemp(exprResultID) << endl;
        oss << ":= " << loopLabel << endl;

        oss << ": " << falseLabel << endl;
        $$->code = oss.str();
        delete $2;
        delete $4;
        delete $6;
        delete $8;
        delete $10;
        delete $12;
    }
| 
    READ var_list { 
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
                // Non-array var
                oss << ".< " << vType.first << endl;
            } else {
                // Array var
                oss << ".[]< " << vType.first << ", " << index << endl;
            }
        }
        $$->code = oss.str();
        delete $2;
    }
| 
    WRITE var_list { 
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
                // Non-array var
                oss << ".> " << vType.first << endl;
            } else {
                // Array var
                oss << ".[]> " << vType.first << ", " << index << endl;
            }
        }
        $$->code = oss.str();
        delete $2;
    }
| 
    CONTINUE {
        $$ = new statement_struct();
        ostringstream oss;
        int continueID = lm->labelGen();

        // Create goto label, push ID to continueIDs
        oss << ":= " << lm->getLabel(continueID) << endl;
        $$->continue_ids.push_back(continueID);
        $$->code = oss.str();
    }
| 
    RETURN expression { 
        $$ = new statement_struct();
        ostringstream oss;

        oss << $2->code;
        oss << "ret " << tm->getTemp($2->result_id) << endl;
        $$->code = oss.str();
        delete $2;
    }
;

conditional: 
    sta_loop { 
        $$ = new conditional_struct();
        ostringstream oss;

        int ifID = lm->labelGen();
        int breakID = lm->labelGen();

        string ifLabel = lm->getLabel(ifID);
        string breakLabel = lm->getLabel(breakID);

        // Label for when if statement is true
        oss << ": " << ifLabel << endl;
        oss << $1->code;
        
        // Label for when if statement is false
        oss << ": " << breakLabel << endl;

        $$->true_id = ifID;
        $$->false_id = breakID;
        $$->code = oss.str();
        $$->continue_ids = $1->continue_ids;
    }
| 
    sta_loop ELSE sta_loop { 
        $$ = new conditional_struct();
        ostringstream oss;

        int ifID = lm->labelGen();
        int elseID = lm->labelGen();
        int breakID = lm->labelGen();

        string ifLabel = lm->getLabel(ifID);
        string elseLabel = lm->getLabel(elseID);
        string breakLabel = lm->getLabel(breakID);

        vector<int> ifContinueIDs = $1->continue_ids;
        vector<int> elseContinueIDs = $3->continue_ids;

        // Label for when if statement is true
        oss << ": " << ifLabel << endl;
        oss << $1->code;
        oss << ":= " << breakLabel << endl;

        // Label for when if statment is false
        oss << ": " << elseLabel << endl;
        oss << $3->code;
        oss << ": " << breakLabel << endl;

        // Get continueIDs from all statements
        for (int i = 0; i < ifContinueIDs.size(); i++) {
            $$->continue_ids.push_back(ifContinueIDs.at(i));
        }
        for (int i = 0; i < elseContinueIDs.size(); i++) {
            $$->continue_ids.push_back(elseContinueIDs.at(i));
        }
        $$->true_id = ifID;
        $$->false_id = elseID;
        $$->code = oss.str();
        delete $1;
        delete $3;
    }
;

var_list: 
    var { 
        $$ = new var_list_struct();
        pair<string, int> vType($1->ident, $1->index_id);
        
        // Put all identifiers with their respective indecies to queue
        // (Identifiers that are not arrays, have index = NOT_ARRAY = -1)
        $$->code = $1->code;
        $$->varTypes.push(vType);
        delete $1;
    }
| 
    var COMMA var_list { 
        $$ = new var_list_struct();
        ostringstream oss;
        pair<string, int> vType;

        oss << $1->code << $3->code;
        $$->code = oss.str();

        // Put all identifiers with their respective indecies to queue
        // (Identifiers that are not arrays, have index = NOT_ARRAY = -1)
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

bool_expr: 
    relation_and_expr { 
        $$ = new bool_expr_struct();
        $$->code = $1->code;
        $$->result_id = $1->result_id;
    }
| 
    relation_and_expr OR relation_and_expr { 
        $$ = new bool_expr_struct();
        ostringstream oss;
        int aResultID = $1->result_id;
        int bResultID = $3->result_id;

        $$->result_id = tm->tempGen();
        oss << $1->code << $3->code;
        oss << ". " << tm->getTemp($$->result_id) << endl;
        oss << "|| " << tm->getTemp($$->result_id) << ", " << tm->getTemp(aResultID) << ", " << tm->getTemp(bResultID) << endl;
        $$->code = oss.str();

    }
;

relation_and_expr: 
    relation_expr { 
        $$ = new relation_and_expr_struct();
        $$->code = $1->code;
        $$->result_id = $1->result_id;
    }
| 
    relation_expr AND relation_and_expr { 
        $$ = new relation_and_expr_struct();
        ostringstream oss;
        int aResultID = $1->result_id;
        int bResultID = $3->result_id;

        $$->result_id = tm->tempGen();
        oss << $1->code << $3->code;
        oss << ". " << tm->getTemp($$->result_id) << endl;
        oss << "&& " << tm->getTemp($$->result_id) << ", " << tm->getTemp(aResultID) << ", " << tm->getTemp(bResultID) << endl;
        $$->code = oss.str();
    }
;

relation_expr: 
    relation_expr_help { 
        $$ = new relation_expr_struct();
        $$->code = $1->code;
        $$->result_id = $1->result_id;
    }
| 
    NOT relation_expr_help { 
        $$ = new relation_expr_struct();
        ostringstream oss;

        $$->result_id = $2->result_id;
        oss << $2->code;
        oss << "! " << tm->getTemp($$->result_id) << ", " << tm->getTemp($$->result_id) << endl;
        $$->code = oss.str();
    }
;

relation_expr_help: 
    expression comp expression { 
        $$ = new relation_expr_help_struct();
        ostringstream oss;
        int frontExprID = $1->result_id;
        int backExprID = $3->result_id;

        $$->result_id = tm->tempGen();
        oss << $1->code << $3->code;
        oss << ". " << tm->getTemp($$->result_id) << endl;

        oss << $2->comp << " " << tm->getTemp($$->result_id) << ", " << tm->getTemp(frontExprID) << ", " << tm->getTemp(backExprID) << endl;
        $$->code = oss.str();
    }
| 
    TRUE { 
        $$ = new relation_expr_help_struct();
        ostringstream oss;
        
        $$->result_id = tm->tempGen();
        oss << ". " << tm->getTemp($$->result_id) << endl;

        oss << "= " << tm->getTemp($$->result_id) << ", 1" << endl;
        $$->code = oss.str();
    }
| 
    FALSE { 
        $$ = new relation_expr_help_struct();
        ostringstream oss;
        
        $$->result_id = tm->tempGen();
        oss << ". " << tm->getTemp($$->result_id) << endl;

        oss << "= " << tm->getTemp($$->result_id) << ", 0" << endl;
        $$->code = oss.str();
    }
| 
    L_PAREN bool_expr R_PAREN { 
        $$ = new relation_expr_help_struct();
        $$->code = $2->code;
        $$->result_id = $2->result_id;
    }
;

comp: 
    EQ { 
        $$ = new comp_struct();
        $$->comp = "=="; 
    }
| 
    NEQ { 
        $$ = new comp_struct();
        $$->comp = "!="; 
    }
| 
    LT { 
        $$ = new comp_struct();
        $$->comp = "<"; 
    }
| 
    GT { 
        $$ = new comp_struct();
        $$->comp = ">"; 
    }
| 
    LTE { 
        $$ = new comp_struct();
        $$->comp = "<="; 
    }
| 
    GTE { 
        $$ = new comp_struct();
        $$->comp = ">="; 
    }
;

expression: 
    multiplicative_expr { 
        $$ = new expression_struct();

        $$->code = $1->code;
        $$->result_id = $1->result_id;
        $$->number = $1->number; 
        delete $1;
    }
| 
    expression ADD multiplicative_expr { 
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
        $$ = new multiplicative_expr_struct();
        
        $$->code = $1->code;
        $$->result_id = $1->result_id;
        $$->number = $1->number; 
        delete $1;
    }
| 
    multiplicative_expr DIV term { 
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
        $$ = new term_struct();
        $$->result_id = $1->result_id;
        $$->code = $1->code;
        $$->number = $1->number; 
        delete $1;
    }
| 
    SUB term_help { 
        $$ = new term_struct();
        ostringstream oss;
        int termHelpReultID = $2->result_id;

        // Creates negative number in with temporary variables, store in code
        oss << $2->code;
        oss << "- " << tm->getTemp(termHelpReultID) << ", 0, " << tm->getTemp(termHelpReultID) << endl;

        // Creates negative number, store in number string
        $$->result_id = termHelpReultID;
        if (! $2->number.empty()) {
            $$->number = "-" + $2->number; 
        }
        $$->code = oss.str();
    }
| 
    ident L_PAREN function_parameters R_PAREN {
        $$ = new term_struct();
        ostringstream oss;
        int functionReturnResultID = tm->tempGen();
        vector<int> paramaterIDs = $3->parameter_ids;

        // Makes function call with parameters
        oss << $3->code;
        for (int i = 0; i < paramaterIDs.size(); i++) {
            oss << "param " << tm->getTemp(paramaterIDs.at(i)) << endl;
        }
        oss << ". " << tm->getTemp(functionReturnResultID) << endl;
        oss << "call " << $1->ident << ", " << tm->getTemp(functionReturnResultID) << endl;
        
        $$->result_id = functionReturnResultID;
        $$->code = oss.str();
        $$->number = "";
        delete $1;
        delete $3;
    }
|
    ident L_PAREN R_PAREN {
        $$ = new term_struct();
        ostringstream oss;
        int functionReturnResultID = tm->tempGen();

        // Makes function call with no parameters
        oss << ". " << tm->getTemp(functionReturnResultID) << endl;
        oss << "call " << $1->ident << ", " << tm->getTemp(functionReturnResultID) << endl;
        
        $$->result_id = functionReturnResultID;
        $$->code = oss.str();
        $$->number = "";
        delete $1;
    }
;

term_help: 
    var { 
        $$ = new term_help_struct();
        $$->code = $1->code;
        $$->result_id = $1->result_id;
        $$->number = "";
        delete $1;
    }
| 
    number { 
        $$ = new term_help_struct();
        $$->code = $1->code;
        $$->result_id = $1->result_id;
        $$->number = $1->number;
        delete $1;
    }
| 
    L_PAREN expression R_PAREN { 
        $$ = new term_help_struct();
        $$->code = $2->code;
        $$->result_id = $2->result_id;
        $$->number = "";
        delete $2;
    }
;

function_parameters:  
    expression {
        $$ = new function_parameters_struct();
        int exprResultID = $1->result_id;

        // Push expression ID to vector as a paramater ID
        $$->parameter_ids.push_back(exprResultID);
        $$->code = $1->code;
        delete $1;
    }
| 
    expression COMMA function_parameters {
        $$ = new function_parameters_struct();
        ostringstream oss;
        int exprResultID = $1->result_id;
        vector<int> paramaterIDs = $3->parameter_ids;

        // Push all parameter result IDs to vector
        oss << $1->code << $3->code;
        $$->parameter_ids.push_back(exprResultID);
        for (int i = 0; i < paramaterIDs.size(); i++) {
            $$->parameter_ids.push_back(paramaterIDs.at(i));
        }
        $$->code = oss.str();
        delete $1;
        delete $3;
    }
;

var: 
    ident { 
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
        $$ = new var_struct();
        ostringstream oss;
        int exprResultID = $3->result_id;

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
        // Pass raw string of identifier
        $$ = new ident_struct();
        $$->ident = $1;
    }
;

number: 
    NUMBER { 
        $$ = new number_struct();
        ostringstream oss;
        stringstream ss;

        // Create temporary variable for number (for use in expressions)
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
  lm = new LabelManager();
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
