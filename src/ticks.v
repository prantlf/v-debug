module debug

pub fn (d &Debug) is_ticking() bool {
	return d.ticking
}

pub fn (d &Debug) start_ticking() {
	if !d.ticking {
		ticking_ptr := &d.ticking
		unsafe {
			*ticking_ptr = true
		}
	}
}

pub fn (d &Debug) stop_ticking() {
	if d.ticking {
		ticking_ptr := &d.ticking
		unsafe {
			*ticking_ptr = false
		}
	}
}

pub fn (d &Debug) set_ticks() {
	init_tick_ptr := &d.init_tick
	last_tick_ptr := &d.last_tick
	unsafe {
		*init_tick_ptr = true
	}
	unsafe {
		*last_tick_ptr = ticks()
	}
}

fn diff_ticks(prev u64, next u64) u64 {
	return if next > prev {
		next - prev
	} else {
		prev - next
	}
}
