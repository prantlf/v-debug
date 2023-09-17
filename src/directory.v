module debug

import os { getwd }
import strings { repeat_string }

pub fn (d &Debug) rwd(path string) string {
	return if d.enabled {
		if color_support > 0 {
			rwd(path)
		} else {
			path
		}
	} else {
		''
	}
}

pub fn rwd(path string) string {
	if rel_len < 0 {
		return path
	}

	wd := getwd()
	path_len := path.len
	wd_len := wd.len

	if rel_len == 0 {
		if path.starts_with(wd) {
			return if path_len == wd_len {
				'.'
			} else {
				'.${path[wd_len..]}'
			}
		}
		return path
	}

	mut i := 0
	mut sep := 0
	for i < wd_len && i < path_len {
		c := path[i]
		if c != wd[i] {
			if rel_len > 0 {
				seps := sep_count(wd, sep + 1)
				if seps < rel_len {
					rel_path := repeat_string('${os.path_separator}..', seps + 1)
					return '.${rel_path}${path[sep..]}'
				}
			}
			return path
		}
		if c == `/` || c == `\\` {
			sep = i
		}
		i++
	}
	return if wd_len < path_len {
		'.${path[wd_len..]}'
	} else if wd_len > path_len {
		if rel_len >= 0 {
			seps := sep_count(wd, path_len)
			if seps <= rel_len {
				rel_path := repeat_string('${os.path_separator}..', seps)
				return '.${rel_path}'
			}
		}
		return path
	} else {
		'.'
	}
}

fn sep_count(path string, from int) int {
	mut seps := 0
	len := path.len
	for i := from; i < len; i++ {
		c := path[i]
		if c == `/` || c == `\\` {
			seps++
		}
	}
	return seps
}
