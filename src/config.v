module debug

import os { getenv }

#include <errno.h>
#include <fcntl.h>

fn C.fcntl(fd int, cmd int, arg ...voidptr) int

struct Name {
	main  string
	layer string
}

struct Config {
	enabled  []Name
	disabled []Name
}

const config = configure()

pub fn (d &Debug) is_enabled() bool {
	return d.enabled
}

pub fn (mut d Debug) enable() {
	d.enabled = true
}

pub fn (mut d Debug) disable() {
	d.enabled = false
}

fn is_enabled(name string) bool {
	name_parts := name.split(':')
	name_both := name_parts.len == 2

	for disabled in debug.config.disabled {
		if name_parts[0] == disabled.main {
			if disabled.layer.len == 0 || (name_both && name_parts[1] == disabled.layer) {
				return false
			}
		}
	}

	for enabled in debug.config.enabled {
		if enabled.main == '*' {
			return true
		}
		if name_parts[0] == enabled.main {
			if enabled.layer.len == 0 || (name_both && name_parts[1] == enabled.layer) {
				return true
			}
		}
	}

	return false
}

fn configure() &Config {
	if C.fcntl(2, C.F_GETFD) == -1 && C.errno == C.EBADF {
		panic('Standard error is not open')
	}

	env := getenv('DEBUG')
	if env.len == 0 {
		return &Config{}
	}

	mut enabled := []Name{}
	mut disabled := []Name{}
	names := env.split(',')
	for name in names {
		name_only, on := split_name(name)
		if on {
			enabled << name_only
		} else {
			disabled << name_only
		}
	}

	return &Config{
		enabled: enabled
		disabled: disabled
	}
}

fn split_name(name string) (Name, bool) {
	on := name[0] != `-`
	name_only := if on {
		name
	} else {
		name[1..]
	}

	parts := name_only.split(':')
	layer := if parts.len > 1 {
		parts[1]
	} else {
		''
	}

	return Name{
		main: parts[0]
		layer: layer
	}, on
}
