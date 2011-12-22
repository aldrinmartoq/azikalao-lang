all: azikalao

clean:
		rm -f AZTokens.m AZParser.m AZParser.h azikalao

AZTokens.m: AZTokens.l
	lex -o $@ $^

AZParser.m: AZParser.y
	bison -d -o AZParser.c $^
	mv AZParser.c AZParser.m

AZNode.m: AZNode.h
	touch AZNode.m

azikalao: AZTokens.m AZParser.m AZCompiler.m AZNode.m
	clang -fobj-arc -framework Foundation -o $@ $^
