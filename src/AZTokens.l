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

#if AZDEBUG
#define TOK(t)  fprintf(stderr, "%s\n", #t); return (yylval.token = t)
#define STR(t) fprintf(stderr, "%s - %s\n", #t, yytext); yylval.strn = [[NSString alloc] initWithBytes:yytext length:yyleng encoding:NSASCIIStringEncoding]; return t
#else
#define TOK(t)  return (yylval.token = t)
#define STR(t) yylval.strn = [[NSString alloc] initWithBytes:yytext length:yyleng encoding:NSASCIIStringEncoding]; return t
#endif

%}

%option noyywrap

D           [0-9]
L           [a-zA-Z_]
LL          [a-zA-Z0-9_]
H           [a-fA-F0-9]
E           [Ee][+-]?{D}+
FS          (f|F|l|L)
IS          (u|U|l|L)*

%%

"require"               TOK(TREQUIRE);      // require
"class"                 TOK(TCLASS);        // class
"end"                   TOK(TEND);          // end
"def"                   TOK(TDEF);          // def
"attr"                  TOK(TATTR);         // attr
"return"                STR(TRETURN);       // return
"if"                    STR(TIF);           // if

"<"                     TOK(TLESSTHAN);     // less than
">"                     TOK(TGREATTHAN);    // greater than
"("                     TOK(TLEFTPAREN);    // left parent
")"                     TOK(TRIGHTPAREN);   // right parent
","                     TOK(TCOMMA);        // comma
"@"                     TOK(TAT);           // at
"."                     TOK(TDOT);          // dot
"="                     TOK(TEQUAL);        // dot

\"(\\.|[^\\"])*\"       STR(TSTRING);       // string
\<(\\.|[^\n])*\>        STR(TSTRING);       // path string <...>
\#.*\n                  STR(TCOMMENT);      // comments start from # to end of line

{L}{LL}*                STR(TIDENTIFIER);   // identifier
[ \t]*\n                STR(TNL);           // new line
[ \t]+                  ;                   // spaces
.                       printf("Unknown token :-/\n"); yyterminate();

%%
