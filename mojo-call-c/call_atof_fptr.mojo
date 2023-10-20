from sys import ffi

alias c_atof_type = fn(s: Pointer[Int8]) -> Float64

def main():
  let handle = ffi.DLHandle("")
  let c_atof = handle.get_function[c_atof_type]("atof")

  let float_str = StringRef("1.234")
  let val = c_atof(float_str.data.as_scalar_pointer())
  print("The parsed Float64 value is: ", val)