module debug

import math { abs }
import os { getenv, getenv_opt }
import term { can_show_color_on_stderr }

$if windows {
	#include <windows.h>
}
fn C.IsWindows10OrGreater() int

const few_colors = ['6', '2', '3', '4', '5', '1']!

const many_colors = [
	'20',
	'21',
	'26',
	'27',
	'32',
	'33',
	'38',
	'39',
	'40',
	'41',
	'42',
	'43',
	'44',
	'45',
	'56',
	'57',
	'62',
	'63',
	'68',
	'69',
	'74',
	'75',
	'76',
	'77',
	'78',
	'79',
	'80',
	'81',
	'92',
	'93',
	'98',
	'99',
	'112',
	'113',
	'128',
	'129',
	'134',
	'135',
	'148',
	'149',
	'160',
	'161',
	'162',
	'163',
	'164',
	'165',
	'166',
	'167',
	'168',
	'169',
	'170',
	'171',
	'172',
	'173',
	'178',
	'179',
	'184',
	'185',
	'196',
	'197',
	'198',
	'199',
	'200',
	'201',
	'202',
	'203',
	'204',
	'205',
	'206',
	'207',
	'208',
	'209',
	'214',
	'215',
	'220',
	'221',
]!

const color_support = detect_colors()

fn get_color(name string) string {
	if debug.color_support == 0 {
		return ''
	}

	mut hash := u32(0)
	for c in name {
		hash = ((hash << 5) - hash) + c
	}

	mut colors := &string(0)
	mut color_count := 0
	colors = if debug.color_support == 1 {
		color_count = debug.few_colors.len
		&debug.few_colors[0]
	} else {
		color_count = debug.many_colors.len
		&debug.many_colors[0]
	}
	color := unsafe { colors[abs(hash) % u32(color_count)] }
	return if color.len == 1 {
		color
	} else {
		'8;5;${color}'
	}
}

fn detect_colors() int {
	force := getenv_opt('FORCE_COLOR') or { '0' }
	min := if force.len > 0 {
		if force == 'true' {
			1
		} else {
			force.int()
		}
	} else {
		1
	}

	if min == 0 && !(can_show_color_on_stderr() && !has_env('NO_COLOR')) {
		return 0
	}

	if has_env('TF_BUILD') && has_env('AGENT_NAME') {
		return 1
	}

	terminal := getenv('TERM')
	if terminal == 'dumb' {
		return min
	}

	$if windows {
		return if C.IsWindows10OrGreater() != 0 {
			2
		} else {
			1
		}
	}

	if has_env('CI') {
		if has_env('GITHUB_ACTIONS') || has_env('GITEA_ACTIONS') {
			return 2
		}
		if has_env('TRAVIS') || has_env('CIRCLECI') || has_env('APPVEYOR') || has_env('GITLAB_CI')
			|| has_env('BUILDKITE') || has_env('DRONE') || getenv('CI_NAME') == 'codeship' {
			return 1
		}
		return min
	}

	if has_env('TEAMCITY_VERSION') {
		return 1
	}

	if getenv('COLORTERM') == 'truecolor' || terminal == 'xterm-kitty' || terminal.ends_with('-256')
		|| terminal.ends_with('-256color') {
		return 2
	}

	if program := getenv_opt('TERM_PROGRAM') {
		if program == 'iTerm.app' || program == 'Apple_Terminal' {
			return 2
		}
	}

	if terminal.starts_with('screen') || terminal.starts_with('xterm')
		|| terminal.starts_with('vt100') || terminal.starts_with('vt220')
		|| terminal.starts_with('rxvt') || terminal.contains('color') || terminal.contains('ansi')
		|| terminal.contains('cygwin') || terminal.contains('linux') || has_env('COLORTERM') {
		return 1
	}

	return min
}

fn has_env(name string) bool {
	return if _val := getenv_opt(name) {
		true
	} else {
		false
	}
}
