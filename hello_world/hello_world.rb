require 'rubygems'
require 'ffi'

module HelloWorld
  extend FFI::Library  
  ffi_lib './libhelloworld.so'
  attach_function :say_hello, [], :void
end

HelloWorld::say_hello
