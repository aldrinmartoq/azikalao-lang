// AZNode.h - AST Nodes declarations
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

#import <Foundation/Foundation.h>

@interface AZNode : NSObject
- (void) compile;
@end

@interface AZStatements : AZNode
@property (retain) NSMutableArray *statements;
@end

@interface AZRequire : AZNode
@property (retain) NSString *path;
@end

@interface AZClassDefinition : AZNode
@property (retain) NSString *name;
@property (retain) NSString *parent;
@property (retain) NSString *category;
@property (retain) NSMutableArray *methods;
@end

@interface AZMethodDefinition : AZNode
@property (retain) NSString *name;
@property (retain) NSString *returnType;
@end

@interface AZText : AZNode
@property (retain) NSString *text;
@end