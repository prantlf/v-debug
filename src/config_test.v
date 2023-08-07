module debug

const d = new_debug('debug')

fn test_log_disabled() {
	debug.d.disable()
	assert debug.d.is_enabled() == false
	debug.d.log('disabled')
}

fn test_log_enabled() {
	debug.d.enable()
	assert debug.d.is_enabled() == true
	debug.d.log('enabled')
}
