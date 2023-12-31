module debug

import os { getenv }

fn test_get_color() {
	expected := if has_env('NO_COLOR') {
		''
	} else {
		if getenv('FORCE_COLOR') == '1' {
			'4'
		} else if has_env('CI') {
			''
		} else {
			'8;5;43'
		}
	}
	assert get_color('debug') == expected
}
