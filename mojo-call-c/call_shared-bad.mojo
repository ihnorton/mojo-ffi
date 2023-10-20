from sys import ffi

def callme():
    var vec = DynamicVector[Float64]()
    vec.push_back(1)
    vec.push_back(2)
    vec.push_back(30)
    vec.push_back(51.112)
    vec.push_back(40)
    vec.push_back(51.0)

    print(external_call["array_max", Float64, Pointer[Float64], Int64](vec.data, len(vec)))


def main():
    ffi.DLHandle("./libdemo.so")

    callme()