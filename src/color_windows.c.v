module debug

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

// #include <VersionHelpers.h>
// fn C.IsWindows10OrGreater() int

// fn C.GetModuleHandleA(moduleName &char) C.HMODULE
// fn C.GetProcAddress(module, C.HMODULE, procName &char) voidptr

fn is_win10_or_greater() bool {
	mh := C.GetModuleHandleA(c'kernel32.dll')
	if mh != C.NULL {
		pa := C.GetProcAddress(mh, c'GetSystemCpuSetInformation')
		return unsafe { pa != nil }
	}
	return false
}
