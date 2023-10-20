This directory demonstrates the creation of a shared library from Mojo, and then calling a function in that shared library from a C executable.

File overview:
- `main.c`: C executable which declares and calls an `extern` function -- the function's symbol must be made available at link time.
- `hello_shared.mojo`: Mojo file with an `@export`-ed function called `hello_mojo`. This function prints fiery greetings. The file is compiled via the `mojoc` helper script which causes the creation of the `libhellomojo.so` shared library.
- `Makefile`: builds and executes all code.

On linux, the following output should be displayed:

```
mojoc -shared hello_shared.mojo -o libhellomojo.so
gcc -L. -lhellomojo main.c -o main -Wl,-rpath=./
./main
<Calling mojo from C...>
🔥🔥🔥🔥🔥🔥🔥🔥 hello from mojo shared library! 🔥🔥🔥🔥🔥🔥🔥🔥
<...Returned to C from mojo>
```