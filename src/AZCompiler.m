// AZCompiler.m - Main compiler
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
extern AZStatements *code;
extern FILE* yyin;
extern int yyparse();

NSMutableString *source = nil;
NSMutableString *header = nil;

int main(int argc, char **argv) {
	
	if (argc < 2) {
		printf("Usage: %s source.az\n", argv[0]);
		return 1;
	}
	
	@autoreleasepool {
		source = [NSMutableString new];
		header = [NSMutableString new];
		
		NSString *masterFile = [[NSString alloc] initWithCString:argv[1] encoding:NSASCIIStringEncoding];
		NSString *sourceFile = [NSString stringWithFormat:@"%@.m", [masterFile stringByDeletingPathExtension]];
		NSString *headerFile = [NSString stringWithFormat:@"%@.h", [masterFile stringByDeletingPathExtension]];
		
		NSString *sourceName = [sourceFile lastPathComponent];
		NSString *headerName = [headerFile lastPathComponent];
		
		[source appendFormat:@"#import \"%@\"\n", headerName];
		
		NSLog(@"compiling: %@", masterFile);

		yyin = fopen(argv[1], "r");
		yyparse();
		[code compile];
		fclose(yyin);

		NSLog(@"header: %@", headerFile);
		NSLog(@"source: %@", sourceFile);
		
		[header writeToFile:headerFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
		[source writeToFile:sourceFile atomically:NO encoding:NSUTF8StringEncoding error:nil];

		return 0;
	}
}
