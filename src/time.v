module debug

import math { round }
import strings { Builder }
import time { Time }

const second = 1000

const minute = second * 60

const hour = minute * 60

const day = hour * 24

fn write_ticks(ms int, mut builder Builder) {
	if ms < debug.second {
		builder.write_string(ms.str())
		builder.write_u8(`m`)
		builder.write_u8(`s`)
	} else {
		mut num := f64(0)
		mut suffix := `\0`
		if ms < debug.minute {
			num = round(f64(ms) / debug.second)
			suffix = `s`
		} else if ms < debug.hour {
			num = round(f64(ms) / debug.minute)
			suffix = `m`
		} else if ms < debug.day {
			num = round(f64(ms) / debug.hour)
			suffix = `h`
		} else {
			num = round(f64(ms) / debug.day)
			suffix = `d`
		}
		builder.write_string(int(num).str())
		builder.write_u8(suffix)
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
	ms := int(round(stamp.microsecond / 1000))
	write_pad3(ms, mut builder)
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
