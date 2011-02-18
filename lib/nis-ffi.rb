require 'ffi'

# NIS module providing the yp functions.
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

  # Runtime error for yp functions.
  #
  # Can be raised from each function when something goes wrong (when the return
  # code isn't 0). Includes the error code and a readable message. The code can
  # be checked against the YPERR constants (e.g. NIS::YPERR_BADARGS).
  class YPError < RuntimeError
    attr_reader :code

    def initialize(code, message)
      super(message)
      @code = code
    end
  end

  module Library
    extend FFI::Library
    begin
      ffi_lib 'nsl'
    rescue LoadError
      begin
        # fall back to libc (Mac OS X is different)
        ffi_lib 'c'
      rescue LoadError
        raise LoadError, "nis-ffi: Neither libnsl nor libc could be loaded, giving up."
      end
    end
    attach_function 'yp_get_default_domain', [:pointer], :int
    attach_function 'yp_match', [:string, :string, :string, :int, :pointer, :pointer], :int
    attach_function 'yperr_string', [:int], :string
  end

  # Get the default domain.
  def self.yp_get_default_domain
    domain_ptr = FFI::MemoryPointer.new(:pointer)
    code = Library.yp_get_default_domain(domain_ptr)
    raise_on_error(code)
    str_ptr = domain_ptr.read_pointer
    str_ptr.read_string
  end

  # Look up a value with a specified map and key.
  #
  # Returns the string value or raises an YPError (even when it's just a key
  # that doesn't exist).
  def self.yp_match(domain, map, key)
    value = FFI::MemoryPointer.new(:pointer)
    value_len = FFI::MemoryPointer.new(:int)

    code = Library.yp_match(domain, map, key, key.bytesize, value, value_len)
    raise_on_error(code)
    
    str_ptr = value.read_pointer
    len = value_len.read_int
    result = str_ptr.read_string(len)
    result
  end

  # Returns an error string which describes the error code.
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
