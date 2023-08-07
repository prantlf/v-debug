module debug

import time { sleep }

const d = new_debug('debug')

fn test_log_no_args() {
	debug.d.log('no args')
}

fn test_log_args() {
	value := 'value'
	debug.d.log('arg %s', value)
}

fn test_log_str() {
	debug.d.log_str('str')
}

fn test_log_lines() {
	debug.d.log_str('first\nsecond')
}

fn test_log_delayed() {
	debug.d.log('early')
	sleep(1_000_000)
	debug.d.log('late')
}
