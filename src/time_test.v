module debug

import strings { new_builder }
import time { Time }

fn format_ticks(ms int) string {
	mut builder := new_builder(8)
	write_ticks(ms, mut builder)
	return builder.str()
}

fn format_now(stamp &Time) string {
	mut builder := new_builder(32)
	write_now(stamp, mut builder)
	return builder.str()
}

fn test_format_ticks_0() {
	assert format_ticks(0) == '0ms'
}

fn test_format_ticks_ms() {
	assert format_ticks(123) == '123ms'
}

fn test_format_ticks_s_down() {
	assert format_ticks(1_234) == '1s'
}

fn test_format_ticks_s_up() {
	assert format_ticks(1_543) == '2s'
}

fn test_format_ticks_m_down() {
	assert format_ticks(61_234) == '1m'
}

fn test_format_ticks_m_up() {
	assert format_ticks(91_234) == '2m'
}

fn test_format_ticks_h_down() {
	assert format_ticks(3_600_123) == '1h'
}

fn test_format_ticks_h_up() {
	assert format_ticks(5_400_123) == '2h'
}

fn test_format_ticks_d_down() {
	assert format_ticks(86_400_123) == '1d'
}

fn test_format_ticks_d_up() {
	assert format_ticks(129_600_123) == '2d'
}

fn test_format_now_1() {
	now := Time{
		year: 2001
		month: 1
		day: 1
		hour: 1
		minute: 1
		second: 1
		microsecond: 1000
	}
	assert format_now(now) == '2001-01-01 01:01:01:001 '
}

fn test_format_now_2() {
	now := Time{
		year: 2010
		month: 10
		day: 11
		hour: 22
		minute: 33
		second: 44
		microsecond: 10000
	}
	assert format_now(now) == '2010-10-11 22:33:44:010 '
}

fn test_format_now_3() {
	now := Time{
		year: 2100
		month: 10
		day: 11
		hour: 22
		minute: 33
		second: 44
		microsecond: 100000
	}
	assert format_now(now) == '2100-10-11 22:33:44:100 '
}
