module debug

import os { getenv }

fn test_get_color() {
	expected := if has_env('NO_COLOR') || has_env('CI') {
		''
	} else {
		if getenv('FORCE_COLOR') == '1' {
			'4'
		} else {
			'8;5;43'
		}
	}
	assert get_color('debug') == expected
}
