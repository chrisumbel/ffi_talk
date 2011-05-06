
require 'rubygems'
require 'ffi'

class Message
  extend FFI::Library

  ffi_lib './libinetchecksum.so'
  attach_function :inet_checksum, [:pointer, :int], :ushort

  def checksum
    ptr = FFI::MemoryPointer.from_string(@data)
    inet_checksum ptr, @data.length
  end

  def initialize(data)
    @data = data
  end
end

puts Message.new(ARGV[0]).checksum
