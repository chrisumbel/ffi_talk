require 'rubygems'
require 'ffi'

module LibC
  extend FFI::Library
  ffi_lib 'c'
  attach_function :getpid, [], :uint
end

puts LibC.getpid
