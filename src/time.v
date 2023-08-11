module debug

import math { round }
import strings { Builder }
import time { Time }

const millisecond = 1_000

const second = millisecond * 1_000

const minute = second * 60

const hour = minute * 60

const day = hour * 24

fn write_ticks(us u64, mut builder Builder) {
	if us < debug.millisecond {
		builder.write_string(us.str())
		builder.write_u8(`u`)
		builder.write_u8(`s`)
	} else {
		if us < debug.second {
			ms := round(f64(us) / debug.millisecond)
			builder.write_string(int(ms).str())
			builder.write_u8(`m`)
			builder.write_u8(`s`)
		} else {
			mut num := f64(0)
			mut suffix := `\0`
			if us < debug.minute {
				num = round(f64(us) / debug.second)
				suffix = `s`
			} else if us < debug.hour {
				num = round(f64(us) / debug.minute)
				suffix = `m`
			} else if us < debug.day {
				num = round(f64(us) / debug.hour)
				suffix = `h`
			} else {
				num = round(f64(us) / debug.day)
				suffix = `d`
			}
			builder.write_string(int(num).str())
			builder.write_u8(suffix)
		}
	}
}

fn write_now(stamp &Time, mut builder Builder) {
	builder.write_u8(`2`)
	write_pad3(stamp.year - 2000, mut builder)
	builder.write_u8(`-`)
	write_pad2(stamp.month, mut builder)
	builder.write_u8(`-`)
	write_pad2(stamp.day, mut builder)
	builder.write_u8(` `)
	write_pad2(stamp.hour, mut builder)
	builder.write_u8(`:`)
	write_pad2(stamp.minute, mut builder)
	builder.write_u8(`:`)
	write_pad2(stamp.second, mut builder)
	builder.write_u8(`:`)
	write_pad6(stamp.nanosecond / 1000, mut builder)
	builder.write_u8(` `)
}

fn write_pad2(num int, mut builder Builder) {
	if num < 10 {
		builder.write_u8(`0`)
		builder.write_u8(`0` + num)
	} else {
		builder.write_u8(`0` + (num / 10))
		builder.write_u8(`0` + (num % 10))
	}
}

fn write_pad3(num int, mut builder Builder) {
	if num < 10 {
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0` + num)
	} else if num < 100 {
		builder.write_u8(`0`)
		builder.write_u8(`0` + (num / 10))
		builder.write_u8(`0` + (num % 10))
	} else {
		builder.write_u8(`0` + (num / 100))
		dec := num % 100
		builder.write_u8(`0` + (dec % 10))
		builder.write_u8(`0` + (dec / 10))
	}
}

fn write_pad6(num int, mut builder Builder) {
	if num < 10 {
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0` + num)
	} else if num < 100 {
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0` + (num / 10))
		builder.write_u8(`0` + (num % 10))
	} else if num < 1_000 {
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0` + (num / 100))
		dec := num % 100
		builder.write_u8(`0` + (dec % 10))
		builder.write_u8(`0` + (dec / 10))
	} else if num < 10_000 {
		builder.write_u8(`0`)
		builder.write_u8(`0`)
		builder.write_u8(`0` + (num / 1_000))
		mut dec := num % 1_000
		builder.write_u8(`0` + (dec / 100))
		dec = dec % 100
		builder.write_u8(`0` + (dec % 10))
		builder.write_u8(`0` + (dec / 10))
	} else if num < 100_000 {
		builder.write_u8(`0`)
		builder.write_u8(`0` + (num / 10_000))
		mut dec := num % 10_000
		builder.write_u8(`0` + (dec / 1_000))
		dec = dec % 1_000
		builder.write_u8(`0` + (dec / 100))
		dec = dec % 100
		builder.write_u8(`0` + (dec % 10))
		builder.write_u8(`0` + (dec / 10))
	} else {
		builder.write_u8(`0` + (num / 100_000))
		mut dec := num % 100_000
		builder.write_u8(`0` + (dec / 10_000))
		dec = dec % 10_000
		builder.write_u8(`0` + (dec / 1_000))
		dec = dec % 1_000
		builder.write_u8(`0` + (dec / 100))
		dec = dec % 100
		builder.write_u8(`0` + (dec % 10))
		builder.write_u8(`0` + (dec / 10))
	}
}
