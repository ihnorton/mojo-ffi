all: call_demo libdemo.a run

libdemo.a: demo.c
	gcc -static -c demo.c -o libdemo.a

call_demo: call_demo.mojo libdemo.a
	mojoc call_demo.mojo -Slibdemo.a -o call_demo

run: FORCE call_demo
	./call_demo

clean:
	rm -f libdemo.a call_demo

FORCE: