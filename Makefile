# Detect host platform
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# lib/aplib64.a is a Linux ELF archive; macOS cannot link it.
# On Darwin we compile lib/aplib_stub.c instead (compression is stubbed out;
# --compress aplib will report an error, all other donut features work normally).
ifeq ($(UNAME_S),Darwin)
  APLIB_OBJ    = lib/aplib_stub.o
  EXTRA_CFLAGS = -Wno-deprecated-declarations
else
  APLIB_OBJ    = lib/aplib64.a
  EXTRA_CFLAGS =
endif

CFLAGS   = -Wunused-function -Wall -fpack-struct=8 $(EXTRA_CFLAGS)
INCLUDES = -I include

donut: clean $(APLIB_OBJ)
	gcc $(CFLAGS) -DDONUT_EXE $(INCLUDES) donut.c hash.c encrypt.c format.c loader/clib.c $(APLIB_OBJ) -odonut
	gcc $(CFLAGS) -c -fPIC $(INCLUDES) donut.c hash.c encrypt.c format.c loader/clib.c
	ar rcs lib/libdonut.a donut.o hash.o encrypt.o format.o clib.o $(APLIB_OBJ)
	gcc -Wall -shared -o lib/libdonut.so donut.o hash.o encrypt.o format.o clib.o $(APLIB_OBJ)

debug: clean $(APLIB_OBJ)
	gcc -Wunused-function -ggdb -Wall -Wno-format -fpack-struct=8 $(EXTRA_CFLAGS) -DDEBUG -DDONUT_EXE $(INCLUDES) donut.c hash.c encrypt.c format.c loader/clib.c $(APLIB_OBJ) -odonut

lib/aplib_stub.o: lib/aplib_stub.c include/aplib.h
	gcc $(INCLUDES) -c -o $@ $<

hash:
	gcc -Wall -Wno-format -fpack-struct=8 -DTEST $(INCLUDES) hash.c loader/clib.c -ohash

encrypt:
	gcc -Wall -Wno-format -fpack-struct=8 -DTEST $(INCLUDES) encrypt.c loader/clib.c -oencrypt

inject:
	gcc -Wall -Wno-format -fpack-struct=8 -DTEST $(INCLUDES) loader/inject.c -oinject

inject_local:
	gcc -Wall -Wno-format -fpack-struct=8 -DTEST $(INCLUDES) loader/inject_local.c -oinject_local

clean:
	rm -f loader.exe exe2h.exe exe2h loader32.exe loader64.exe \
	      donut.o hash.o encrypt.o format.o clib.o lib/aplib_stub.o \
	      hash encrypt donut hash.exe encrypt.exe donut.exe \
	      lib/libdonut.a lib/libdonut.so
