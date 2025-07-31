# debug

Tiny, simple and fast debug logging library.

* No log levels - just enable or disable.
* Enabling using two-level namespaces.
* Time duration from the previous or other log entry on the level of a microsecond.
* Colourful output to standard error.

Inspired by [debug at NPM].

## Synopsis

```go
import prantlf.debug { new_debug }

d := new_debug('test')

file_name := 'test.txt'
d.log('Creating file "%s"', file_name)
...
d.log_str('Done')
```

## Installation

You can install this package either from [VPM] or from GitHub:

```txt
v install prantlf.debug
v install --git https://github.com/prantlf/v-debug
```

## Output

If the current terminal supports colours, they will be used them emphasize the logging instance name (bold) and time duration since the last log message (regular). The colour will be selected from a palette of 76 colours using a hash computed from the logging instance name.

    test Creating file "text.txt" +0us
    test Done +21us

If the standard error doesn't support colours, the date and time of the log message will be printed in front of the log message. When inspecting a log file later, times of log entry messages can't be related to the execution time any more.

    2023-07-16 23:50:56:801000 test Creating file "text.txt"
    2023-07-16 23:50:56:822000 test Done

Setting the environment variable `DEBUG_HIDE_DATE` will omit the date and time from the log message, if colours aren't supported.

    test Creating file "text.txt"
    test Done

Setting the environment variable `DEBUG_SHOW_DATE` will print the date and time in front of the log message, even if colours are supported. Setting the environment variable `DEBUG_HIDE_TIME` will omit the the duration between log entries, even if colours are supported. Setting the environment variable `DEBUG_SHOW_TIME` will print the duration between log entries, even if colours aren't supported.

If the log message contains line breaks, they will be preserved. All lines Such log message will be prefixed by the logging instance name and optional time and one suffix (optional duration) and the lines will be left aligned by spaces to start at the same column.

## Configuration

A logging instance name is a string consisting of a main name and optionally of a layer name. If the name contains colon (`:`), the part after the colon will be used as a layer name.

```go
d := new_debug('http')     // an instance with the name "http"
d := new_debug('http:net') // an instance with the name "http:net"
```

Set the `DEBUG` environment variable to a comma-delimited (`,`) list of enabling or disabling of logging instance names. Prefixing a name with a dash (`-`) means disabling. The asterisk (`*`) means enabling all names.

    DEBUG="*"              # enable all instances
    DEBUG="http"           # enable all layers of "http" instance
    DEBUG="http:net"       # enable only "http:net" instance
    DEBUG="*,-http"        # enable all instances except for "http:net"
    DEBUG="http,-http:net" # enable all layers of "http" instance except for "http:net"

Setting environment variables is possible on the same command line too.

### Not Windows

    DEBUG="*,-http:net" your_command

### Windows

    set DEBUG=*,-http:net & your_command

### PowerShell

    $env:DEBUG="*,-http:net"; your_command

### NPM Script

    "your_script": "cross-env DEBUG=*,-http:net your_command"

## API

The following functions and types are exported:

### new_debug(name string) &Debug

Creates a new debug logging instance. Initialisation - enabling and colour support detection - is performed using process environment.

```go
import prantlf.debug { new_debug }

// One-level name, global logger
const d = new_debug('test')

// Two-level name for a specific software layer, local logger
d := new_debug('curl:net')
```

### Debug.is_enabled() bool

Checks if the debug logging is enabled in this instance. The `log` method doesn't perform any formatting and just bails out, if the debug logging is disabled, but you may need to use this method to avoid some expensive data preparation for the logging purposes.

```go
if d.is_enabled() {
  config_name := 'config.yaml'
  config := os.read_file(config_name)!
  d.log_str('Configuration from "${config_name}":\n${config}')
}
```

### Debug.enable()

Enables the debug logging in this instance. Although the debug logging is usually enabled using process environment, you may want to enable it programmatically too.

```go
if arg == '--debug' {
  d.enable()
}
```

### Debug.disable()

Disables the debug logging in this instance. You might need to disable it temporarily and later enable it again.

```go
enabled := d.is_enabled()
if enabled {
  d.disable()
}
// now perform some task always without logging
if enabled {
  d.enable()
}
```

### Debug.log(format string, ...arguments)

Prints a log message to the standard error if the debug logging is enabled in this instance. Otherwise it doesn't perform anything, not even string formatting, and just bails out. The message `format` and variadic `arguments` are expected as specified for the [printf] function family known from `C`.

```go
answer := 42
d.log('Answer to the ultimate question: %d', answer)
```

Just make sure that you pass variables and not expressions as variadic parameters. The `log` method, just like the underlying `strconv.v_sprintf`, requires all arguments convertible to `voidptr`. The following code will fail compiling, because a pointer to a memory address can't be computed for an expression, at least not in the current version of the V compiler:

```go
d.log('Answer to the ultimate question: %d', 42) // FAILURE
```

### Debug.log_str(text string)

Prints a log message to the standard error if the debug logging is enabled in this instance. Otherwise it doesn't perform anything and just bails out.

```go
d.log_str('Looking for the ultimate question')
```

### Debug.rwd(path string) string

Returns a path relative to the current working directory, if the debug logging is enabled in this instance. Otherwise it will return an empty string. Also, if the current terminal doesn't support colours, this method will always return the input, absolute path. Paths in log files are supposed to be absolute. See the static `rwd` below for more information.

```go
dfile_name := d.rwd(file_name)
d.log('Creating file "%s"', dfile_name)
```

### rwd(path string) string

Returns a path relative to the current working directory for logging purposes. It can be used to put shorter paths to log and error messages, which will make them easier to follow. It isn't affected by enabling of the debug logging like the class method above.

```go
return error('Creating file "${debug.rwd(file_name)}" failed')
```

If the input path isn't based on the current working directory, but the parent path is, the result can still be returned as a relative path, if the current working directory is only one or two parent paths farther from the common root directory, common to both the input path and the current working directory.

    path: /Users/prantlf/Sources/v-debug
    cwd:  /Users/prantlf/Sources/v-debug
    rwd:  .

    path: /Users/prantlf/Sources/v-debug/src
    cwd:  /Users/prantlf/Sources/v-debug
    rwd:  ./src

    path: /Users/prantlf/Sources
    cwd:  /Users/prantlf/Sources/v-debug
    rwd:  ./..

    path: /Users/prantlf/Sources/v-cargs
    cwd:  /Users/prantlf/Sources/v-debug
    rwd:  ./../v-cargs

    path: /Users/other
    cwd:  /Users/prantlf/Sources/v-debug
    rwd:  /Users/other

The length of the path fragment to the common directory root can be controlled by the environment variable `DEBUG_REL_PATH`. If set to an empty string, logging relative paths will be disabled. If set to a zero, input paths will have to start with the current working directory to be considered relative. If set to a number greater than zero, the common relative root will be movable to the specified number of directories below the common directory, which may include one or more `'..'` parts in the output relative path.

### Debug.shorten(s string) string

Returns either the input string as-is, or shortened to a maximum length, if the debug logging is enabled in this instance. Otherwise it will return an empty string. See the static `shorten` below for more information.

```go
description_s := d.shorten(description)
d.log('Entered description "%s"', description_s)
```

### Debug.shorten_within(s string, start int, stop int) string

Works like the method `shorten`, just using a part of the input string. If `stop` is `-1`, the full string length will be used.

### shorten(s string) string

Returns either the input string as-is, or shortened to a maximum length. It can be used to put beginnings of strings to log as a hint to error messages, which will make them easier to follow. It isn't affected by enabling of the debug logging like the class method above.

```go
return error('Saving the description "${shorten(description)}" failed')
```

The maximum of length of the shortened string can be adjusted with the environment variable `DEBUG_SHORT_LEN`. The default value is `30`. If the input string length exceeds the maximum, the string will be trimmed to the maximum length *in the middle* and `...` (three dots) will be inserted to the middle. If the environment variable is set to `-1`, the shortening will be disabled and the full string will be returned.

### shorten_within(s string, start int, stop int) string

Works like the function `shorten`, just using a part of the input string. If `stop` is `-1`, the full string length will be used.

### Debug.is_ticking() bool

Returns if the microsecond clock measuring time between two consecutive log entries is ticking. If not, the upcoming log entry won;t contain the time duration from the previous log entry. See the `stop_ticking` method below for more information.

### Debug.start_ticking()

Starts the microsecond clock measuring time between two consecutive log entries, if it was stopped before, otherwise it has no effect. See the `stop_ticking` method below for more information.

### Debug.stop_ticking()

Stops if the microsecond clock measuring time between two consecutive log entries, if it was ticking, otherwise it has no effect.

If you log very often, the microsecond ticks will be come very small or even zero. It won't be helpful for measuring time durations of your applications any more. Sometimes you will want to measure the time that the whole function needed to execute and not just one loop iteration. For example:

```go
fn compute () {
  d.log_str('Computing a new answer')
  d.stop_ticking()
  for try in trials {
    d.log('Trying "%s"', trial)
    ...
  }
  d.start_ticking()
  d.log('Computed answer "%s"', answer)
}
```

Only the last log entry from the function above will contain the time duration and it will be the time duration between the calls to `stop_ticking` and `start_ticking` methods:

    Computing a new answer +1us
    Trying "a"
    Trying "b"
    ...
    Computed answer "u" +134us

## Global Usage

When implementing logging in an application or command line tool, it's more convenient to create one global logging object and use it in each source file:

```go
__global (
  d := new_debug('newchanges')
)

fn run() ! {
  d.log_str('starting')
  ...
}
```

Than creating the logging object in the `main` function and that pass it to each other function or structure, which would introduce a lot of function arguments throughout the source code:

```go
fn run(d &Debug) ! {
  d.log_str('starting')
  ...
}

fn main() {
  d := new_debug('newchanges')
  run(d) or {
    eprintln(err)
    exit(1)
  }
}
```

When implementing logging in a library, the logging object would pollute even the logging interface. However, using global variables has to be enabled by the compiler switch `-enable-globals`, which may not be acceptable by everybody. So, how to allow the library to log independently on its interface and and don't require enabling globals?

### Solution

The solution is using a *constant* global logging object. Global constants compile without limitations:

```go
const d = new_debug('newchanges')

fn run() ! {
  d.log_str('starting')
  ...
}
```

### Trick

However, the logging object would have to be initialised only when the application starts and it wouldn't be able to carry a state, which would be changeable, like a time difference to the previous log entry. While this may be sufficient for a very simple logging object - initialised only using environment variables, no state - when the logging library develops, it'd become a painful limitation soon.

Because a constant is handled only in the V compiler and can be overridden in the C code, there's a trick to modify the logging object even in the constant context:

```go
pub fn (d &Debug) enable() {
  enabled_ptr := &d.enabled
  unsafe { *enabled_ptr = true }
}
```

This isn't safe in multi-threaded context. Using the same logging object in multiple threads might not be reliable. On the other hand, separate threads should use their own loggers, because their log entries wouldn't be distinguishable, and thus the risk of something broken because of this trick is negligible.

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Lint and test your code.

## License

Copyright (c) 2023-2025 Ferdinand Prantl

Licensed under the MIT license.

[VPM]: https://vpm.vlang.io/packages/prantlf.debug
[debug at NPM]: https://www.npmjs.com/package/debug
[printf]: https://man7.org/linux/man-pages/man3/fprintf.3p.html
