%{
// AZParser.y - AST generator, based on bison.
// Azikalao
// 
// Copyright (C) 2011 Aldrin Martoq A.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "AZNode.h"
AZStatements *code;

extern int yylex();
void yyerror(const char *msg) {
    printf("Something went wrong: %s\n", msg);
}

#define CHKARR(x) if (x == nil) x = [NSMutableArray new]

%}

%union {
    AZNode              *node;
    AZRequire           *requ;
    AZStatements        *stms;
    AZClassDefinition   *clas;
    AZMethodDefinition  *meth;
    AZText              *text;

    NSMutableArray      *array;
    NSString            *string;
    int                 token;
}

/* tokens */
%token <string> TSP TNL TID TFL TIN TS1 TS2 TCM TEO
%token <token>  TRE TCL TEN TDE
%token <token>  TIF
%token <token>  TLP TRP TAT TCO TLT TGT

/* types */
%type <stms> program statements
%type <requ> require
%type <node> statement
%type <clas> class_definition
%type <meth> method_definition
%type <text> comment empty_line
%type <array> method_definitions
%type <string> identifier

%start program

%%

program
    : statements
        { code = $1; }
    ;

statements
    : statement
        { $$ = [[AZStatements alloc] init]; [$$.statements addObject:$1]; }
    | statements statement
        { [$1.statements addObject:$2]; }
    ;

statement
    : empty_line
        { $$ = $1;}
    | comment
        { $$ = $1;}
    | require
        { $$ = $1; }
    | class_definition
        { $$ = $1; }
    ;

require
    : TRE TS1 TEO
        { $$ = [AZRequire new]; $$.path = $2; }
    | TRE TS2 TEO
        { $$ = [AZRequire new]; $$.path = $2; }
    ;

class_definition
    : TCL identifier TEO
        method_definitions
      TEN
        { $$ = [AZClassDefinition new]; $$.name = $2; $$.methods = $4; }
    | TCL identifier TLT identifier TEO
        method_definitions
      TEN
        { $$ = [AZClassDefinition new]; $$.name = $2; $$.parent = $4; $$.methods = $6; }
    | TCL identifier TLP identifier TRP TEO
        method_definitions
      TEN
        { $$ = [AZClassDefinition new]; $$.name = $2; $$.category = $4; $$.methods = $7; }
    ;

method_definitions
    : /* empty */
        { $$ = nil; }
    | method_definition
        { $$ = [NSMutableArray new]; [$$ addObject:$1]; }
    | method_definitions method_definition
        { CHKARR($$); [$$ addObject: $2]; }
    | method_definitions comment
        { CHKARR($$); [$$ addObject: $2]; }
    | method_definitions empty_line
        { CHKARR($$); [$$ addObject: $2]; }
    ;
    
method_definition
    : TDE identifier TEO
      TEN TEO
        { $$ = [AZMethodDefinition new]; $$.name = $2; }
    | TDE identifier TGT identifier TEO
      TEN TEO
        { $$ = [AZMethodDefinition new]; $$.name = $2; $$.returnType = $4; }
    ;

comment
    : TCM
        { $$ = [AZText new]; $$.text = [NSString stringWithFormat:@"//%@", [$1 substringFromIndex:1]]; }
    ;

empty_line
    : TEO
        { $$ = [AZText new]; $$.text = $1; }
    ;

identifier
    : TID { $$ = $1; }
    ;

%%
