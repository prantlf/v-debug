module debug

import os { getenv }

__global (
	d = new_debug('debug')
)

fn test_init() {
	expected := getenv('DEBUG') == 'debug'
	assert d.is_enabled() == expected
}
