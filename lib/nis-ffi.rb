require 'ffi'

module NIS
  
  YPERR_SUCCESS = 0
  YPERR_BADARGS = 1
  YPERR_RPC     = 2
  YPERR_DOMAIN  = 3
  YPERR_MAP     = 4
  YPERR_KEY     = 5
  YPERR_YPERR   = 6
  YPERR_RESRC   = 7
  YPERR_NOMORE  = 8
  YPERR_PMAP    = 9
  YPERR_YPBIND  = 10
  YPERR_YPSERV  = 11
  YPERR_NODOM   = 12
  YPERR_BADDB   = 13
  YPERR_VERS    = 14
  YPERR_ACCESS  = 15
  YPERR_BUSY    = 16

  class YPError < RuntimeError
    attr_reader :code

    def initialize(code, message)
      super(message)
      @code = code
    end
  end

  module Library
    extend FFI::Library
    ffi_lib 'nsl'
    attach_function 'yp_match', [:string, :string, :string, :int, :pointer, :pointer], :int
    attach_function 'yperr_string', [:int], :string
  end

  def self.yp_match(domain, map, key)
    value = FFI::MemoryPointer.new(:pointer)
    value_len = FFI::MemoryPointer.new(:int)

    code = Library.yp_match(domain, map, key, key.bytesize, value, value_len)
    raise_on_error(code)
    
    str_ptr = value.read_pointer
    len = value_len.read_int
    if len > 0
      result = str_ptr.read_string(len)
      result
    else
      nil
    end
  end

  def self.yperr_string(code)
    Library.yperr_string(code)
  end

  private

  def self.raise_on_error(code)
    if code != YPERR_SUCCESS
      message = yperr_string(code)
      raise YPError.new(code, message)
    end
  end
end
