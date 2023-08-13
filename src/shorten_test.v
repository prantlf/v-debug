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

fn test_debug_shorten_within() {
	expected := if getenv('DEBUG') == 'debug' {
		'a'
	} else {
		''
	}
	assert debug.d.shorten_within('a', 0, 1) == expected
}

fn test_shorten_within_empty() {
	assert shorten_within('', 0, 0) == ''
}

fn test_shorten_within_short() {
	assert shorten_within('123', 0, 3) == '123'
}

fn test_shorten_within_short_autolen() {
	assert shorten_within('123', 0, -1) == '123'
}

fn test_shorten_within_tail() {
	assert shorten_within('123', 1, -1) == '23'
}

fn test_shorten_within_head() {
	assert shorten_within('123', 0, 2) == '12'
}

fn test_shorten_within_body() {
	assert shorten_within('123', 1, 2) == '2'
}

fn test_shorten_within_cross() {
	assert shorten_within('123', 2, 1) == ''
}

fn test_shorten_within_at_end() {
	assert shorten_within('123', 3, -1) == ''
}

fn test_shorten_within_beyond() {
	assert shorten_within('123', 4, -1) == ''
}

fn test_shorten_within_long() {
	assert shorten_within('1234567890123456789012345678901', 0, -1) == '123456789012345...789012345678901'
}

fn test_shorten_within_not_long() {
	assert shorten_within('1234567890123456789012345678901', 1, -1) == '234567890123456789012345678901'
}

fn test_shorten_within_long_tail() {
	assert shorten_within('12345678901234567890123456789012', 1, -1) == '234567890123456...890123456789012'
}
