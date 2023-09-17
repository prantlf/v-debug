module debug

[noinit]
pub struct Debug {
	name  string
	color string
mut:
	enabled   bool
	ticking   bool = true
	init_tick bool
	last_tick u64
}

pub fn new_debug(name string) &Debug {
	dbg := &Debug{
		name: name
		enabled: is_enabled(name)
		color: get_color(name)
	}
	return dbg
}
