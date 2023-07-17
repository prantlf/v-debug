module debug

__global (
	d = new_debug('debug')
)

fn test_log_disabled() {
	d.disable()
	assert d.is_enabled() == false
	d.log('disabled')
}

fn test_log_enabled() {
	d.enable()
	assert d.is_enabled() == true
	d.log('enabled')
}
