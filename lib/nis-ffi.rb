require 'ffi'

module NIS

  module Library
    extend FFI::Library
    ffi_lib 'nsl'
    attach_function 'yp_match', [:string, :string, :string, :int, :pointer, :pointer], :int
  end

  def self.yp_match(domain, map, key)
    value = FFI::MemoryPointer.new(:pointer)
    value_len = FFI::MemoryPointer.new(:int)

    result = Library.yp_match(domain, map, key, key.bytesize, value, value_len)
    str_ptr = value.read_pointer
    len = value_len.read_int
    if len > 0
      return str_ptr.read_string_length(len)
    else
      return nil
    end
  end
end
