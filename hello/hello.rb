require 'rubygems'
require 'ffi'

module Hello
  extend FFI::Library
  
  ffi_lib './libhello.so'
  attach_function :say_hello, [:string], :void
end

Hello::say_hello ARGV[0] # <-- NULL terminated
