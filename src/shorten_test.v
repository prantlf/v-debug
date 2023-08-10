module debug

import os { getenv }

const d = new_debug('debug')

fn test_debug_shorten() {
	expected := if getenv('DEBUG') == 'debug' {
		'a'
	} else {
		''
	}
	assert debug.d.shorten('a') == expected
}

fn test_shorten_empty() {
	assert shorten('') == ''
}

fn test_shorten_short() {
	assert shorten('123') == '123'
}

fn test_shorten_long() {
	assert shorten('1234567890123456789012345678901') == '123456789012345...789012345678901'
}

fn test_debug_shorten_ext() {
	expected := if getenv('DEBUG') == 'debug' {
		'a'
	} else {
		''
	}
	assert debug.d.shorten_ext('a', 0, 1) == expected
}

fn test_shorten_ext_empty() {
	assert shorten_ext('', 0, 0) == ''
}

fn test_shorten_ext_short() {
	assert shorten_ext('123', 0, 3) == '123'
}

fn test_shorten_ext_short_autolen() {
	assert shorten_ext('123', 0, -1) == '123'
}

fn test_shorten_ext_tail() {
	assert shorten_ext('123', 1, -1) == '23'
}

fn test_shorten_ext_head() {
	assert shorten_ext('123', 0, 2) == '12'
}

fn test_shorten_ext_body() {
	assert shorten_ext('123', 1, 2) == '2'
}

fn test_shorten_ext_cross() {
	assert shorten_ext('123', 2, 1) == ''
}

fn test_shorten_ext_at_end() {
	assert shorten_ext('123', 3, -1) == ''
}

fn test_shorten_ext_beyond() {
	assert shorten_ext('123', 4, -1) == ''
}

fn test_shorten_ext_long() {
	assert shorten_ext('1234567890123456789012345678901', 0, -1) == '123456789012345...789012345678901'
}

fn test_shorten_ext_not_long() {
	assert shorten_ext('1234567890123456789012345678901', 1, -1) == '234567890123456789012345678901'
}

fn test_shorten_ext_long_tail() {
	assert shorten_ext('12345678901234567890123456789012', 1, -1) == '234567890123456...890123456789012'
}
