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

If the standard error doesn't support colours, the date and time of the log message will be printed in front of the log message.

    2023-07-16 23:50:56:801 Creating file "text.txt"
    2023-07-16 23:50:56:822 Done

Setting the environment variable `DEBUG_HIDE_DATE` will omit the date and time from the log message, if colours aren't supported.

    Creating file "text.txt"
    Done

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
  d.log('Configuration from "%s":\n%s', config_name, config)
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


### Usage Instructions

The `usage` parameter is the formatted text to be presented as usage instructions. It's supposed to contain a line Starting with `Options:`, which is followed by links listing the options:

    Options:
      -o|--output <file>  write the JSON output to a file
      -p|--pretty         prints the JSON output with line breaks and indented

An option-line can contain a short (single-letter) option, a long option or both. The option can be either a boolean flag or an variable with a value.

    -p             a boolean flag, short variant only
    --line-breaks  a boolean flag, long variant only
    -v|--verbose   a boolean flag, both short and long variants
    -o <file>      a variable with a value

Short and long option variants can be delimited either by `|` or by `,`, which can be followed by a space. A value of a variable can be enclose either in `<` and `>`, or in `[` and `]`.

### Options

Two command-line options will be recognised and processed by the `parse` function itself:

* `-V|--version` - prints the version of the executable and exits
* `-h|--help` - prints the usage information and exits

Short (single-letter) options can be condensed together. For example, instead of `-l -p`, you can write `-lp` on the command line.

Names of fields in the options structure are inferred from the command-line option names with several changes to ensure valid V syntax:

* The long variant of an option will be mapped to its field name. The short variant will be used only if the long variant is missing.
* Upper-case letters will converted to lower-case.
* Dashes (`-`) in an option name will be converted to underscores (`_`) in its field name.

If you write a short (single-letter) option for a boolean flag in upper-case, it will set the value `false` to the boolean field instead of `true`. If you write a long option for a boolean flag, you can negate its value by prefixing the option with `no-`:

    -P --no-line-breaks

Enum field types can be filled either by an integer or by the (string) name of the enum value.

Assigning boolean flags or variable values to option fields may fail. For example:

* If there's no field with the long name of the option.
* If the field type is boolean but the option isn't a boolean flag or vice versa.
* If the field type isn't a string and the field value cannot be converted from the string value.
* If the numeric field type is too small to accommodate the number converted from the string value.

An option with a value can be entered multiple times. All values can be stored in an array, for example:

```go
usage := '...

Options:
  -n, --numbers <number>  a list of numbers to use

...'

struct Opts {
  numbers []int
}
```

### Other Arguments

An option starts with `-` or `--` and has to consist of at least one more letter. A single dash (`-`) isn't an option, but another argument. An argument not starting with a dash (`-`) is a plain argument and not an option.

If you want to handle some argument as other arguments and not as options, put two dashes (`--`) on the command line and appends such arguments behind it. The two dashes (`--`) will be ignored. If you need the two dashes (`--`) as another argument, append them once more after the first ones to the command line.

### Input Fields

The following input fields are available:

| Field                    | Type        | Default     | Description                                                  |
|:-------------------------|:------------|:------------|:-------------------------------------------------------------|
| `version`                | `string`    | `'unknown'` | version of the tool to print if `-V|--version` is requested  |
| `args`                   | `?[]string` | `none`      | raw command-line arguments, defaults to `os.args[1..]`       |
| `disable_short_negative` | `bool`      | `false`     | disables handling uppercase letters as negated options       |
| `ignore_number_overflow` | `bool`      | `false`     | ignores an overflow when converting numbers to option fields |

### Advanced

If the transformation of options name to field name [described above](#options) isn't enough, the argument name can be assigned to a specific field by the attribute `arg`. For example, set the command-line argument `type` to a field `typ`:

```go
usage := '...

Options:
  -t|--type <type>  file type (text or binary)

...'

struct Opts {
  typ string [arg: @type]
}
```

If you don't want to disable the checks for arithmetic overflow globally, but only for one field, it's possible by the attribute `nooverflow`. For example, set the command-line argument `type` to a field `typ`:

```go
usage := '...

Options:
  -r|--random <number>  the value to initialize random number generator with

...'

struct Opts {
  random i16 [nooverflow]
}
```

If you require an option to be always entered, it's possible by the attribute `required`. For example:

```go
usage := '...

Options:
  -f|--file <name>  the name of the output file

...'

struct Opts {
  file string [required]
}
```

If you need to supply multiple values for an option and you want to use more condensed syntax then repeating the option on the command line, you can supply all values only once, if there's a separator, which otherwise cannot be present within a value. For example, you can supply two comma-delimited integers as `-n 1,2` by the attribute `split`:

```go
usage := '...

Options:
  -n, --numbers <number>  a list of numbers to use

...'

struct Opts {
  numbers []int [split]
}
```

The default separator is `,` (comma). If you need a different one, you can choose the separator by the same attribute. For example, you can supply two semicolon-delimited characters as `-c a;b` by the attribute `split`:

```go
usage := '...

Options:
  -c, --chars <char>  allowed characters

...'

struct Opts {
  numbers []rune [split: ';']
}
```

[VPM]: https://vpm.vlang.io/packages/prantlf.jany
[debug at NPM]: https://www.npmjs.com/package/debug
