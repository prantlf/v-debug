module debug

pub fn (d &Debug) shorten(s string) string {
	return if d.enabled {
		shorten(s)
	} else {
		''
	}
}

pub fn (d &Debug) shorten_within(s string, start int, stop int) string {
	return if d.enabled {
		shorten_within(s, start, stop)
	} else {
		''
	}
}

@[direct_array_access]
pub fn shorten(s string) string {
	if short_len < 0 || short_len >= s.len || s.len == 0 {
		return s
	}

	return '${s[..half_short_len]}...${s[s.len - half_short_len..]}'
}

@[direct_array_access]
pub fn shorten_within(s string, start int, end int) string {
	stop := if end < 0 || end > s.len {
		s.len
	} else {
		end
	}

	return if start >= stop {
		''
	} else if short_len < 0 || short_len >= stop - start {
		s[start..stop]
	} else {
		'${s[start..start + half_short_len]}...${s[stop - half_short_len..stop]}'
	}
}
