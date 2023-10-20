# Calling C functions from Mojo

Mojo supports at least two methods to call C functions:

1. (documented) [`external_call`](https://docs.modular.com/mojo/stdlib/sys/intrinsics.html#external_call).

    `external_call` takes the function name, return type, and up to six (?) argument types as parameters, and then the corresponding argument values as input. However, `external_call` _does not_ currently support specifying the function library name, so by default it can only call functions in libc. More on that later.

    A simple `external_call` looks like this:

    ```
    let eightball = external_call["rand", Int32]()
    print(eightball)
    ```

    Which will call the [`rand`](https://en.cppreference.com/w/c/numeric/random/rand) function in the C stdlib, with return type `Int32` (first parameter) and no function arguments.

    For a more complicated example, see [`call_div.mojo`](call_div.mojo) in this directory, which passes two arguments to the [`div`](https://en.cppreference.com/w/c/numeric/math/div) function, and retrieves the return values via a struct.

2. (undocumented?) Declare a function pointer type, and just ... call it! Mojo appears to use the platform C calling convention for at least simple `fn` alias declarations. Such function pointers may be loaded using `sys.ffi.DLHandle` (undocumented) and then called.

    See [`call_atof_fptr.mojo`](call_atof_fptr.mojo) for a full example, which demonstrates calling [`atof`](https://en.cppreference.com/w/c/string/byte/atof) to parse a C string and return a double value from the string.

(TODO: it is likely possible to make external calls via embedded MLIR as well...)

# Functions in non-libc libraries

The examples linked above use functions from the C standard library, which is implicitly available in the REPL, or explicitly linked by `mojo build`. But there are many other useful C functions in the world which we might want to call. Here is an overview of the options.

## Call a shared library from the REPL

*(note: be sure to run `make` in this directory, before trying the examples below; they depend on the existence of `libdemo.so`)*

Using `external_call` in the REPL only requires that the function name is locatable in the process image. `sys.ffi.DLHandle("shared-lib.so")` will cause `shared-lib.so` to be loaded, and presumably uses `dlopen` under the hood. (using `ctypes.CDLL` via Python integration also works)

*However*, there is a very large caveat: the call to `DLHandle` *must* happen in a separate REPL/notebook cell, before the cell which contains the `external_call` is executed (for the same reason that `mojo run` fails, detailed below).

Run this first:
```mojo
from sys import ffi
ffi.DLHandle("./libdemo.so")
```

Then this:
```mojo
var vec = DynamicVector[Float64]()
vec.push_back(1)
vec.push_back(2)
vec.push_back(30)
vec.push_back(51.112)
vec.push_back(40)
vec.push_back(51.0)

print(external_call["array_max", Float64, Pointer[Float64], Int64](vec.data, len(vec)))
```

The program should print `51.112`.

## Call a shared library from `mojo run` (TBD?)

A logical next step is to start from the code above and add a `main` block around it, then execute that function with `mojo run`, or compile with `mojo build`.

Using `mojo run`, the result will look like this (see [call_shared-bad.mojo](call_shared-bad.mojo)):

```
JIT session error: Symbols not found: [ array_max ]
mojo: error: Failed to materialize symbols: { (exec, { main }) }
```

This fails, because the JIT must resolve all symbols during the compilation phase, whereas, currently, `array_max` would only be available after the `DLHandle` function is executed.

## Call a library from a Mojo compiled executable

With `mojo build`, on the other hand, the binary fails to link:

```
call_shared-bad.mojo:(.text+0x104): undefined reference to `array_max'
collect2: error: ld returned 1 exit status
mojo: error: failed to link executable
```

`mojo build` does not yet support linker arguments. However, for fun, this repository includes helper code in `scripts/` which can hook the compilation process and create a Mojo executable statically-linked against an external library. See the following directory for more information:

- [Statically linking a Mojo executable against an external library](../mojo-exe-link-c-static/)

# Exporting a C-callable function from Mojo

Mojo accepts an `@export` annotation on `fn` definitions, which marks the following function for C export (in change log, otherwise undocumented). `scripts/mojoc` can also create a shared library from mojo code. See the following for a full demo:

- [Creating a shared library from Mojo, and calling it from C](../c-link-mojo-shared/)
