# TA-Lib Everywhere

**DEPRECATED — install `TA-Lib>=0.6.5` instead.**

This project is now a thin shim around the official
[TA-Lib](https://github.com/TA-Lib/ta-lib-python) package.
It ships no Python modules or binary wheels of its own and simply depends on the upstream distribution.

Unsupported environments such as Python versions earlier than 3.9 or musl-based systems like Alpine Linux do not currently receive official wheels. For those cases you may need to build TA-Lib from source or seek community-provided binaries.

## Acknowledgements

This project is based on these excellent open-source projects:

- [TA-Lib/ta-lib-python](https://github.com/TA-Lib/ta-lib-python) - Python wrapper for TA-Lib
- [cgohlke/talib-build](https://github.com/cgohlke/talib-build) - TA-Lib build tools

## License

This project follows the same BSD license as the original TA-Lib.

