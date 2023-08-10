module debug

pub fn (d &Debug) shorten(s string) string {
	return if d.enabled {
		shorten(s)
	} else {
		''
	}
}

pub fn (d &Debug) shorten_ext(s string, start int, stop int) string {
	return if d.enabled {
		shorten_ext(s, start, stop)
	} else {
		''
	}
}

[direct_array_access]
pub fn shorten(s string) string {
	if short_len < 0 || short_len >= s.len || s.len == 0 {
		return s
	}

	return '${s[..half_short_len]}...${s[s.len - half_short_len..]}'
}

[direct_array_access]
pub fn shorten_ext(s string, start int, stop int) string {
	end := if stop < 0 || stop > s.len {
		s.len
	} else {
		stop
	}
	if start >= end {
		return ''
	}
	if short_len < 0 || short_len >= end - start {
		return s[start..end]
	}

	return '${s[start..start + half_short_len]}...${s[end - half_short_len..end]}'
}
