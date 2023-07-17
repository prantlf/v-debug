module debug

[noinit]
pub struct Debug {
mut:
	name      string
	enabled   bool
	color     string
	last_time int
}

pub fn new_debug(name string) &Debug {
	mut debug := &Debug{
		name: name
		enabled: is_enabled(name)
		color: get_color(name)
	}
	return debug
}
