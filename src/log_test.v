module debug

import time { sleep }

__global (
	d = new_debug('debug')
)

fn test_log_no_args() {
	d.log('no args')
}

fn test_log_args() {
	value := 'value'
	d.log('arg %s', value)
}

fn test_log_str() {
	d.log_str('str')
}

fn test_log_lines() {
	d.log_str('first\nsecond')
}

fn test_log_delayed() {
	d.log('early')
	sleep(1000000)
	d.log('late')
}
