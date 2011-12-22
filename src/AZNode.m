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
		AZLog(@"Creating: %@", self);
	}

	return self;
}
- (void) compile {
	AZLog(@"Compile %@", self);
}
@end

@implementation AZDeclares
@synthesize decls;
- (id) init {
	if (self = [super init] ) {
		decls = [NSMutableArray new];
	}

	return self;
}
- (void) compile {
	[super compile];

	for (AZNode *n in decls) {
		[n compile];
	}
}
- (NSString *) description {
	return [NSString stringWithFormat:@"%@ %d decls.", [self class], [[self decls] count]];
}
@end

@implementation AZText
@synthesize text;
- (void) compile {
	[super compile];

	[header appendString:text];
	[source appendString:text];
}
- (NSString *) description {
	return [NSString stringWithFormat:@"%@ text: %@", [self class], text];
}
@end

@implementation AZVarDecl
@synthesize type;
@synthesize name;
@synthesize pntr;
@end

@implementation AZRequire
@synthesize path;
- (void) compile {
	[super compile];

	[header appendFormat:@"#import %@", path];
}
- (NSString *) description {
	return [NSString stringWithFormat:@"%@ path: %@", [self class], path];
}
@end

@implementation AZClass
@synthesize name;
@synthesize parent;
@synthesize category;
@synthesize decls;
- (void) compile {
	[super compile];

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

	for (AZNode *p in decls) {
		[p compile];
	}

	[header appendFormat:@"@end"];
	[source appendFormat:@"@end"];
}
- (NSString *) description {
	return [NSString stringWithFormat:@"%@ name: %@ parent: %@ category: %@ decls: %d", [self class], name, parent, category, [decls count]];
}
@end

@implementation AZProperty
@synthesize mods;
@synthesize vard;
- (void) compile {
	[super compile];

	[header appendFormat:@"@property "];
	if (mods) {
		[header appendFormat:@"(%@) ", mods];
	}
	[header appendFormat:@"%@ ", vard.type];
	if (vard.pntr) {
		[header appendString:@"*"];
	}
	[header appendFormat:@"%@;", vard.name];

	[source appendFormat:@"@synthesize %@", vard.name];
}
- (NSString *) description {
	return [NSString stringWithFormat:@"%@ mods: %@ vard: %@", [self class], mods, vard];
}
@end

@implementation AZMethod
@synthesize name;
@synthesize returnType;
- (void) compile {
	[super compile];

	NSString *type = [NSString stringWithFormat:@"%@", (returnType ? returnType : @"void") ];
	
	[header appendFormat:@"- (%@) %@;", type, name];
	[source appendFormat:@"- (%@) %@ {}", type, name];
}
- (NSString *) description {
	return [NSString stringWithFormat:@"%@ name: %@ returnType: %@", [self class], name, returnType];
}
@end
