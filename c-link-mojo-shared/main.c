#include <stdio.h>

extern void hello_mojo();

int main(int argc, char** argv) {
  (void)argc; (void)argv;

  printf("<Calling mojo from C...>\n");
  hello_mojo();
  printf("<...Returned to C from mojo>\n");
}