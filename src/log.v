module debug

import strconv { v_sprintf }
import strings { Builder, new_builder }
import time { now }

type FixedWriter = fn (mut builder Builder)

pub fn (d &Debug) log(format string, arguments ...voidptr) {
	if d.enabled {
		s := unsafe { v_sprintf(format, ...arguments) }
		d.do_log(s)
	}
}

pub fn (d &Debug) log_str(s string) {
	if d.enabled {
		d.do_log(s)
	}
}

fn (d &Debug) do_log(s string) {
	mut builder := new_builder(80)
	if color_support > 0 {
		d.write_with_colors(s, mut builder)
	} else {
		d.write_without_colors(s, mut builder)
	}
	builder.write_u8(`\n`)
	write_out(builder.data, builder.len)
}

fn (d &Debug) write_without_colors(s string, mut builder Builder) {
	name := d.name

	mut write_separator := unsafe { FixedWriter(nil) }
	if hide_date {
		write_separator = fn [name] (mut builder Builder) {
			builder.write_string(name)
			builder.write_u8(` `)
		}
	} else {
		stamp := now()
		write_separator = fn [name, stamp] (mut builder Builder) {
			write_now(stamp, mut builder)
			builder.write_string(name)
			builder.write_u8(` `)
		}
	}

	write_separator(mut builder)
	write_message(s, mut builder, write_separator)

	if show_time && d.ticking {
		builder.write_u8(` `)
		builder.write_u8(`+`)
		diff_time := d.advance_time()
		write_ticks(diff_time, mut builder)
	}
}

fn (d &Debug) write_with_colors(s string, mut builder Builder) {
	name := d.name
	color := d.color

	mut write_separator := unsafe { FixedWriter(nil) }
	if show_date {
		stamp := now()
		write_separator = fn [name, color, stamp] (mut builder Builder) {
			write_now(stamp, mut builder)
			write_prefix(name, color, mut builder)
		}
	} else {
		write_separator = fn [name, color] (mut builder Builder) {
			write_prefix(name, color, mut builder)
		}
	}

	write_separator(mut builder)
	write_message(s, mut builder, write_separator)

	if !hide_time && d.ticking {
		builder.write_u8(` `)
		write_color(d.color, mut builder)
		builder.write_u8(`m`)
		builder.write_u8(`+`)
		diff_time := d.advance_time()
		write_ticks(diff_time, mut builder)
		write_uncolor(mut builder)
	}
}

fn (d &Debug) advance_time() u64 {
	tick := ticks()
	last_tick_ptr := &d.last_tick
	return if d.init_tick {
		prev_ticks := d.last_tick
		unsafe {
			*last_tick_ptr = tick
		}
		diff_ticks(prev_ticks, tick)
	} else {
		init_tick_ptr := &d.init_tick
		unsafe {
			*init_tick_ptr = true
		}
		unsafe {
			*last_tick_ptr = tick
		}
		0
	}
}

fn write_message(s string, mut builder Builder, write_separator FixedWriter) {
	if s.contains_u8(`\n`) {
		lines := s.split_into_lines()
		mut next := false
		for line in lines {
			if next {
				builder.write_u8(`\n`)
				write_separator(mut builder)
			} else {
				next = true
			}
			builder.write_string(line)
		}
	} else {
		builder.write_string(s)
	}
}

fn write_out(data &u8, len int) {
	mut ptr := unsafe { data }
	mut rest := len
	for rest > 0 {
		out := C.write(2, ptr, rest)
		if out < 0 {
			return
		}
		rest = rest - out
		ptr = unsafe { ptr + out }
	}
}

fn write_prefix(name string, color string, mut builder Builder) {
	write_color(color, mut builder)
	builder.write_string(';1m')
	builder.write_string(name)
	write_uncolor(mut builder)
	builder.write_u8(` `)
}

fn write_color(color string, mut builder Builder) {
	builder.write_string('\u001B[3')
	builder.write_string(color)
}

fn write_uncolor(mut builder Builder) {
	builder.write_string('\u001B[0m')
}
