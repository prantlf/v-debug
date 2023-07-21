# debug

Tiny, simple and fast debug logging library.

* No log levels - just enable or disable.
* Enabling using for two-level namespaces.
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

    test Creating file "text.txt" +0ms
    test Done +21ms

If the standard error doesn't support colours, the date and time of the log message will be printed in front of the log message. When inspecting a log file later, times of log entry messages can't be related to the execution time any more.

    2023-07-16 23:50:56:801 test Creating file "text.txt"
    2023-07-16 23:50:56:822 test Done

Setting the environment variable `DEBUG_HIDE_DATE` will omit the date and time from the log message, if colours aren't supported.

    test Creating file "text.txt"
    test Done

If the log message contains line breaks, they will be preserved. All lines Such log message will be prefixed by the logging instance name and optional time and one suffix (optoinal duration) and the lines will be left aligned by spaces to start at the same column.

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

    "your_script": "@powershell -Command $env:DEBUG='*,-http:net'; your_command"

## API

The following functions and types are exported:

### new_debug(name string) &Debug

Creates a new debug logging instance. Initialisation - enabling and colour support detection - is performed using process environment. Make sure that you mark the variable mutable; when logging, the value of elapsed time is constantly increased.

```go
import prantlf.debug { new_debug }

// One-level name, global logger
__globals (
  d = new_debug('test')
)

// Two-level name for a specific software layer, local logger
mut d := new_debug('curl:net')
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

Prints a log message to the standard error if the debug logging is enabled in this instance. Otherwise it doesn't perform anything, not even string formatting, and just bails out. The message `format` and variadic `arguments` are expected as specified for the `printf` function family known from `C`.

```go
answer := 42
d.log('Answer to the ultimate question: %d', answer)
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

Returns a path relative to the current working directory for logging purposes. It can be used to put shorter paths to log and error messages, which will make them easier to follow.

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

[VPM]: https://vpm.vlang.io/packages/prantlf.jany
[debug at NPM]: https://www.npmjs.com/package/debug
