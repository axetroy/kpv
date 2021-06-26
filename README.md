# kpv

![ci](https://github.com/axetroy/kpv/workflows/ci/badge.svg)
![Latest Version](https://img.shields.io/github/v/release/axetroy/kpv.svg)
![License](https://img.shields.io/github/license/axetroy/kpv.svg)
![Repo Size](https://img.shields.io/github/repo-size/axetroy/kpv.svg)

Kill the process listening on the specified port.

support Windows/Linux/macOS

## Installation

If you are using `unix` style system(`macOS`/`Linux`). enter the command line to install.

```shell
# install the latest version
curl -fsSL https://raw.githubusercontent.com/axetroy/kpv/master/install.sh | bash
# install the specified version
curl -fsSL https://raw.githubusercontent.com/axetroy/kpv/master/install.sh | bash -s v0.1.2
```

Or download [the release file](https://github.com/axetroy/kpv/releases) for your platform and put it to `$PATH` folder.

## Usage

```sh
$ kpv --help
kpv - Kill the process listening on the specified port
USAGE:
    kpv <OPTIONS> <...PORTS>
OPTIONS:
    -h,--help                        print help informatino
    -V,--version                     print version information
    -f,--force                       kill forcing
EXAMPLE:
    kpv 1080 9527                    kill multiple ports
    kpv -f 1080                      kill the process by forcing
VERSION:
    v0.1.2
SOURCE CODE:
    https://github.com/axetroy/kpv
```

## Build from source

```sh
$ make
```

## LICENSE

The [MIT License](LICENSE)
