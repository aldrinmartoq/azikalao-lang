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
AZDeclares *master;

extern int yylex();
void yyerror(const char *msg);

#define CHKARR(x) if (x == nil) x = [NSMutableArray new]

NSString *azpropmods(NSString *s1, NSString *s2);
NSString *azcomment(NSString *s);

%}

%union {
    AZNode          *node;
    AZDeclares      *decl;
    AZRequire       *requ;
    AZClass         *clas;
    AZText          *text;
    AZProperty      *prop;
    AZMethod        *meth;
    AZVarDecl       *vard;

    NSString        *strn;
    int             token;
}

/* tokens */
%token <strn>   TIDENTIFIER
%token <token>  TREQUIRE
%token <token>  TCLASS
%token <token>  TEND
%token <token>  TDEF
%token <token>  TATTR
%token <token>  TLESSTHAN
%token <token>  TGREATTHAN
%token <token>  TLEFTPAREN
%token <token>  TRIGHTPAREN
%token <token>  TCOMMA
%token <token>  TAT
%token <strn>   TNL
%token <strn>   TCOMMENT
%token <strn>   TSTRING

/* types */
%type <decl>    program
%type <decl>    declarations
%type <node>    declaration
%type <requ>    require
%type <clas>    class
%type <clas>    class_declaration
%type <decl>    class_body
%type <node>    class_body_element
%type <text>    comment_line
%type <text>    empty_line
%type <meth>    class_method
%type <prop>    class_property
%type <strn>    class_property_mods
%type <vard>    var_decl

%start program

%%

program
    :   declarations
        { master = $1; }
    ;

declarations
    :   declaration
        { $$ = [AZDeclares new]; [$$.decls addObject:$1]; }
    |   declarations declaration
        { [$1.decls addObject:$2]; }
    ;

declaration
    :   require
        { $$ = $1; }
    |   class
        { $$ = $1; }
    |   comment_line
        { $$ = $1; }
    |   empty_line
        { $$ = $1; }
    ;

require
    :   TREQUIRE TSTRING
        { $$ = [AZRequire new]; $$.path = $2; }
    ;

class
    :   class_declaration
        TEND
        { $$ = $1; }
    |   class_declaration
            class_body
        TEND
        { $$ = $1; $$.decls = $2.decls; }
    ;

class_declaration
    :   TCLASS TIDENTIFIER TNL
        { $$ = [AZClass new]; $$.name = $2; }
    |   TCLASS TIDENTIFIER TLESSTHAN TIDENTIFIER TNL
        { $$ = [AZClass new]; $$.name = $2; $$.parent = $4; }
    |   TCLASS TIDENTIFIER TLEFTPAREN TIDENTIFIER TRIGHTPAREN TNL
        { $$ = [AZClass new]; $$.name = $2; $$.category = $4; }
    ;

class_body
    :   class_body_element
        { $$ = [AZDeclares new]; [$$.decls addObject:$1]; }
    |   class_body class_body_element
        { [$1.decls addObject:$2]; }
    ;

class_body_element
    :   class_method
        { $$ = $1; }
    |   class_property
        { $$ = $1; }
    |   comment_line
        { $$ = $1; }
    |   empty_line
        { $$ = $1; }
    ;

class_method
    :   TDEF TIDENTIFIER TNL
        TEND
        { $$ = [AZMethod new]; $$.name = $2; }
    |   TDEF TIDENTIFIER TGREATTHAN TIDENTIFIER TNL
        TEND
        { $$ = [AZMethod new]; $$.name = $2; $$.returnType = $4; }
    ;

class_property
    :   TATTR var_decl
        { $$ = [AZProperty new]; $$.vard = $2; }
    |   TATTR TLEFTPAREN class_property_mods TRIGHTPAREN var_decl
        { $$ = [AZProperty new]; $$.vard = $5; $$.mods = $3; }
    ;

class_property_mods
    :   TIDENTIFIER
        { $$ = $1; }
    |   class_property_mods TCOMMA TIDENTIFIER
        { $$ = azpropmods($1, $3); }
    ;

var_decl
    :   TIDENTIFIER TAT TIDENTIFIER
        { $$ = [AZVarDecl new]; $$.type = $1; $$.name = $3; $$.pntr = YES; }
    |   TIDENTIFIER TIDENTIFIER
        { $$ = [AZVarDecl new]; $$.type = $1; $$.name = $2;}
    ;

comment_line
    :   TCOMMENT
        { $$ = [AZText new]; $$.text = azcomment($1); }
    ;

empty_line
    :   TNL
        { $$ = [AZText new]; $$.text = $1; }
    ;

%%

void yyerror(const char *msg) {
     fprintf(stderr, "Something went wrong: %s\n", msg);
}

NSString *azpropmods(NSString *s1, NSString *s2) {
    return [NSString stringWithFormat:@"%@,%@", s1, s2];
}

NSString *azcomment(NSString *s) {
    return [NSString stringWithFormat:@"//%@", [s substringFromIndex:1]];
}