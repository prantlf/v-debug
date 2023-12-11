module debug

// #include <sys/time.h>

// struct C.timeval {
// 	tv_sec  C.time_t
// 	tv_usec C.suseconds_t
// }

// struct C.timezone {
// 	tz_minuteswest int
// 	tz_dsttime     int
// }

// fn C.gettimeofday(tv &C.timeval, tz &C.timezone) int

fn ticks() u64 {
	tv := C.timeval{}
	C.gettimeofday(&tv, 0)
	return u64(tv.tv_sec) * 1_000_000 + tv.tv_usec
}
