This directory demonstrates the creation of an executable from Mojo, which calls a C function in a statically-linked external library.

File overview:
- `demo.c`: exports the C function `call_this`, which prints a greeting.
- `call_demo.mojo`: Mojo `main` function which calls `call_this` using `external_call`. In order to statically link `call_demo.mojo` against `libdemo`, we use the `mojoc` helper script.
- `Makefile`: builds and runs all code. On linux, the following output should be displayed:

```
gcc -static -c demo.c -o libdemo.a
mojoc call_demo.mojo -Slibdemo.a -o call_demo
./call_demo
<calling statically-linked function from mojo>
hello from static library
<returned to mojo>
```
