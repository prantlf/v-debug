module debug

import math { abs }
import time { sleep }

const d = new_debug('debug')

fn test_ticks() {
	usec1 := ticks()
	sleep(1_000_002_000)
	usec2 := ticks()
	assert abs(usec2 - usec1) > 1_000_001
	assert abs(usec2 - usec1) < 1_300_000
}

fn test_diff_ticks() {
	usec1 := ticks()
	sleep(2_000)
	usec2 := ticks()
	usec3 := diff_ticks(usec1, usec2)
	assert usec3 > 0
	assert usec3 < 1500
}

fn test_log_ticks() {
	assert debug.d.is_ticking()
	debug.d.log_str('tick 1')
	debug.d.stop_ticking()
	assert !debug.d.is_ticking()
	debug.d.log_str('tick 2')
	sleep(1_000)
	debug.d.start_ticking()
	assert debug.d.is_ticking()
	debug.d.log_str('tick 3')
}
