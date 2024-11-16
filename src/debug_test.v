module debug

import os { getenv }

const d = new_debug('debug')

fn test_init() {
	expected := getenv('DEBUG') == 'debug'
	assert d.is_enabled() == expected
}
