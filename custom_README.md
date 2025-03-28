# TA-Lib Everywhere

This project provides pre-compiled TA-Lib (Technical Analysis Library) Python packages for various operating systems and Python versions. These wheel files allow you to install TA-Lib directly **without** compiling from source or having the TA-Lib C library pre-installed on your system.


## Acknowledgements

This project is based on these excellent open-source projects:

- [TA-Lib/ta-lib-python](https://github.com/TA-Lib/ta-lib-python) - Python wrapper for TA-Lib
- [cgohlke/talib-build](https://github.com/cgohlke/talib-build) - TA-Lib build tools


## Why Use TA-Lib Everywhere?

We are [FinLab](https://www.finlab.tw), a team of financial data scientists/engineers. We use TA-Lib in our daily work to develop trading strategies and analyze financial data. We created TA-Lib Everywhere to make it easier for everyone to use TA-Lib in their Python projects.


## Installation

You can install the latest version of TA-Lib Everywhere using pip:

```bash
pip install ta-lib-everywhere
```

## Compatibility Table

TA-Lib Everywhere supports the following platform and Python version combinations:

| Python Version | Linux (x86_64) | Linux (aarch64) | macOS (universal2) | Windows (x86_64) | Windows (x86) |
|----------------|----------------|-----------------|---------------------|------------------|---------------|
| 3.10           | ✅             | ✅              | ✅                  | ✅               | ✅            |
| 3.11           | ✅             | ✅              | ✅                  | ✅               | ✅            |
| 3.12           | ✅             | ✅              | ✅                  | ✅               | ✅            |
| 3.13           | ✅             | ✅              | ✅                  | ✅               | ✅            |

## Usage

After installation, you can import and use it just like the original TA-Lib:

```python
import talib
import numpy as np

# Create a sample price data
close = np.random.random(100)

# Calculate a simple moving average
sma = talib.SMA(close, timeperiod=10)
print(sma)
```
## License

This project follows the same BSD license as the original TA-Lib.