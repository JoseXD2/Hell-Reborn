local ffi = require("ffi")  -- Load FFI module (instance)

local user32 = ffi.load("user32")   -- Load User32 DLL handle

ffi.cdef([[
enum{
    MB_OK = 0x00000000L,
    MB_ICONINFORMATION = 0x00000040L
};

typedef void* HANDLE;
typedef HANDLE HWND;
typedef const char* LPCSTR;
typedef unsigned UINT;

int MessageBoxA(HWND, LPCSTR, LPCSTR, UINT);
]]) -- Define C -> Lua interpretation


function onEvent(name, value1, value2)
    if name == 'MessageBox' then
	user32.MessageBoxA(nil, value2, value1, ffi.C.MB_OK + ffi.C.MB_ICONINFORMATION)   -- Call C function 'MessageBoxA' from User32
end
end