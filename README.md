Let's make Objective-C pretty
===

Azikalao is a new programming language that tries to fix the Objective-C ugliness with a ruby-like syntax. It has a syntax similar to Ruby - but it's not Ruby!

[Read my article about why we need this.][1]

### Sample code
The current implementation is a preprocessor: translates from Azikalao to Objective-C.
Given the following Azikalao source code **sample01.az**:

    # sample code for azikalao
    require <Foundation/Foundation.h>
    require "MyOtherClass.h"
    
    class Foo
    end
    
    class Bar < NSObject
        def init > id
        end
        
        def something
        end
    end

And running the following command:

    $ azikalao sample01.az

The compiler will generate two files: first, the header file **sample01.h**:

    // sample code for azikalao
    #import <Foundation/Foundation.h>
    #import "MyOtherClass.h"
    
    @interface Foo
    @end
    
    @interface Bar : NSObject
    - (id) init;
        
    - (void) something;
    @end

And second, the source file **sample01.m**:

    #import "sample01.h"
    // sample code for azikalao
    
    @implementation Foo
    @end
    
    @implementation Bar
    - (id) init {}
        
    - (void) something {}
    @end

To compile this to your machine, you should run something like this:

    $ clang -o sample01.o sample01.m

## Requirements

Everything is developed on a OS X Lion system. If you want to try it on Linux or other systems, you'll have to collect and build all the pieces.

Current requirements are:

- clang compiler from LLVM
- an Objective-C runtime
- Automatic Reference Counting (ARC) support

Please tell me if you got it running in Linux, thanks!

## What's next

This project is alpha software, everything is really unstable and not production ready, particularly the language spec.

I would love to incorporate this to LLVM, so we could make amazing stuff and use this thing for real (Hello Apple guys!).

My first goal is to make the language self-hosted, that means it should compile itself. When that happens, I will release the 0.1 version to the world.

  [1]: http://aldrin.martoq.cl/techblog/?p=355