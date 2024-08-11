module debug

import os { getenv, getwd }

const d = new_debug('debug')

fn last_sep(path string) int {
	slash := path.last_index_u8(`/`)
	backslash := path.last_index_u8(`\\`)
	return if slash > backslash {
		slash
	} else {
		backslash
	}
}

fn test_debug_rwd() {
	path := '${getwd()}${os.path_separator}test'
	expected := if getenv('DEBUG') == 'debug' {
		if getenv('NO_COLOR') == '1' || has_env('CI') {
			path
		} else {
			'.${os.path_separator}test'
		}
	} else {
		''
	}
	assert debug.d.rwd(path) == expected
}

fn test_rwd_same_path() {
	path := getwd()
	assert rwd(path) == '.'
}

fn test_rwd_longer_path() {
	path := '${getwd()}${os.path_separator}test'
	assert rwd(path) == '.${os.path_separator}test'
}

fn test_rwd_shorter_path() {
	mut path := getwd()
	sep := last_sep(path)
	path = path[..sep]
	assert rwd(path) == '.${os.path_separator}..'
}

fn test_rwd_diverged_path() {
	mut path := getwd()
	sep := last_sep(path)
	path = '${path[..sep + 1]}other'
	assert rwd(path) == '.${os.path_separator}..${os.path_separator}other'
}
