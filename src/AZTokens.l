%{ 
// AZTokens.l - token generator, based on flex.
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
#import "AZParser.h"

#define DBGSIMPLE(t)  printf("%s\n", #t); return (yylval.token = t)
#define DBGCOMPLEX(t) printf("%s - %s\n", #t, yytext); yylval.string = [[NSString alloc] initWithBytes:yytext length:yyleng encoding:NSASCIIStringEncoding]; return t

#define SIMPLE(t)  return (yylval.token = t)
#define COMPLEX(t) yylval.string = [[NSString alloc] initWithBytes:yytext length:yyleng encoding:NSASCIIStringEncoding]; return t

%}

D           [0-9]
L           [a-zA-Z_]
H           [a-fA-F0-9]
E           [Ee][+-]?{D}+
FS          (f|F|l|L)
IS          (u|U|l|L)*

%option noyywrap

%%

"require"               SIMPLE(TRE);        // require
"class"                 SIMPLE(TCL);        // class
"end"                   SIMPLE(TEN);        // end
"def"                   SIMPLE(TDE);        // def

"("                     SIMPLE(TLP);        // left parent
")"                     SIMPLE(TRP);        // right parent
"<"                     SIMPLE(TLT);        // less than
">"                     SIMPLE(TGT);        // less than
"@"                     SIMPLE(TAT);        // at
":"                     SIMPLE(TCO);        // colon

L?\"(\\.|[^\\"])*\"     COMPLEX(TS1);       // string
L?\<(\\.|[^\n])*\>     COMPLEX(TS2);       // string
\#.*\n                  COMPLEX(TCM);       // comment

[ \t]*\n                COMPLEX(TEO);       // ENDOFLINE
[ \t]+                  ; // SAVE_TOKEN; return TSP; // spaces
[a-zA-Z_][a-zA-Z0-9_]*  COMPLEX(TID); // identifier
[0-9]+\.[0-9]*          COMPLEX(TFL); // float
[0-9]+                  COMPLEX(TIN); // integer
.                       printf("Unknown token :-/\n"); yyterminate();

%%
