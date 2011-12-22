AZIKALAO=../src/azikalao

all: check-build s01 sample01

check-build:
	cd ../src && make

s01: s01.az
	$(AZIKALAO) $^

sample01: sample01.az
	$(AZIKALAO) $^

clean:
	rm -f *.h *.m
