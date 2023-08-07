module debug

// fn C.clock_gettime_nsec_np(int) u64

fn ticks() u64 {
	ns := C.clock_gettime_nsec_np(C.CLOCK_UPTIME_RAW)
	return ns / 1_000
}
