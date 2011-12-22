// AZNode.m - AST Nodes and code generator.
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

extern NSMutableString *source;
extern NSMutableString *header;

@implementation AZNode

- (id) init {
	if (self = [super init] ) {
		// NSLog(@"Creating: %@", self);
	}
	
	return self;
}

- (void) compile {
}
@end

@implementation AZStatements
@synthesize statements;

- (id) init {
	if ( self = [super init] ) {
		statements = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) compile {
	for (AZNode *n in statements) {
		[n compile];
	}
}
@end

@implementation AZRequire
@synthesize path;

- (void) compile {
	[header appendFormat:@"#import %@\n", path];
}
@end

@implementation AZClassDefinition
@synthesize name;
@synthesize parent;
@synthesize category;
@synthesize methods;

- (void) compile {
	[header appendFormat:@"@interface %@", name];
	if (parent) {
		[header appendFormat:@" : %@", parent];
	}
	if (category) {
		[header appendFormat:@" (%@)", category];
	}
	[header appendString:@"\n"];

	[source appendFormat:@"@implementation %@", name];
	if (category) {
		[source appendFormat:@" (%@)", category];
	}
	[source appendString:@"\n"];
	
	for (AZMethodDefinition *m in methods) {
		[m compile];
	}

	[header appendFormat:@"@end"];
	[source appendFormat:@"@end"];
}
@end

@implementation AZMethodDefinition
@synthesize name;
@synthesize returnType;

- (void) compile {
	NSString *type = [NSString stringWithFormat:@"%@", (returnType ? returnType : @"void") ];
	
	[header appendFormat:@"- (%@) %@;\n", type, name];
	[source appendFormat:@"- (%@) %@ {}\n", type, name];
}
@end

@implementation AZText
@synthesize text;

- (void) compile {
	[header appendString:text];
	[source appendString:text];
}
@end
