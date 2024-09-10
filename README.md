# Mojo FFI Notes

1. [Calling C libraries from Mojo](mojo-call-c/)
2. [Statically linking a Mojo executable against a C library](mojo-exe-link-c-static/) (demo)
3. [Creating a shared library from Mojo, and calling it from C](c-link-mojo-shared/) (demo)

In order to run 2 and 3, add `scripts/` to your `PATH` before using the demo `Makefile`s (or invoke `/this/path/scripts/mojoc` directly). The scripts require `python` to be available in `PATH`.

(note: the scripts have not yet been updated to support macOS, but the approach should work with minor modifications)

or you can use 
```bash
source setup.sh
```
this will make the Makefiles on 3 work properly