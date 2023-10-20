def main():
  print("<calling statically-linked function from mojo>")
  external_call["call_this", NoneType]()
  print("<returned to mojo>")
