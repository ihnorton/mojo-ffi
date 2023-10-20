all: libhellomojo.so main run

main: main.c libhellomojo.so
	gcc -L. -lhellomojo main.c -o main -Wl,-rpath=./

libhellomojo.so: hello_shared.mojo
	mojoc -shared hello_shared.mojo -o libhellomojo.so

run: FORCE
	./main

clean:
	rm -f main libhellomojo.so

FORCE: