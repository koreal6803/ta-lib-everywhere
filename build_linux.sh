#!/bin/bash
set -e

# Get architecture and Python version from arguments
ARCH=$1
PY_VERSION=$2

# Install build tools
yum install -y wget git

# Download and install TA-Lib C library
cd /tmp
wget https://github.com/ta-lib/ta-lib/releases/download/v0.6.4/ta-lib-0.6.4-src.tar.gz -q
tar -xzf ta-lib-0.6.4-src.tar.gz
cd ta-lib-0.6.4/

# Configure with architecture-specific flags
if [ "$ARCH" == "aarch64" ]; then
  ./configure --build=aarch64-unknown-linux-gnu --prefix=/usr
else
  ./configure --prefix=/usr
fi

make -j$(nproc)
make install

# Create symbolic link for library name compatibility
cd /work
ln -s /usr/lib/libta-lib.so.0 /usr/lib/libta_lib.so.0

# Find the matching Python version
PYTHON_PATH="/opt/python/cp${PY_VERSION//./}*/bin/python"

# Check if Python exists for this version
if ! ls $PYTHON_PATH >/dev/null 2>&1; then
  echo "Python $PY_VERSION not available in manylinux image" > /work/dist/python-unavailable.txt
  exit 0
else
  # More robust Python interpreter selection
  echo "Available Python interpreters:"
  ls -la $PYTHON_PATH
  
  # Choose Python interpreter using full path and explicit glob expansion
  PYTHON_INTERPRETERS=(/opt/python/cp${PY_VERSION//./}*/bin/python)
  PYTHON="${PYTHON_INTERPRETERS[0]}"
  
  echo "Selected Python interpreter: $PYTHON"
  
  # Verify the Python interpreter works
  if ! $PYTHON --version; then
    echo "Python interpreter found but not functioning properly"
    exit 1
  fi
fi

# Install Python dependencies
$PYTHON -m pip install --upgrade pip setuptools wheel build 'numpy>=2.0' auditwheel

# Verify TA-Lib C library installation
echo "Verifying TA-Lib installation:"
nm -D /usr/lib/libta_lib.so.0 | grep TA_AVGDEV_Lookback

# Build wheel with explicit library paths
cd ta-lib-python
export TA_INCLUDE_PATH=/usr/include
export TA_LIBRARY_PATH=/usr/lib
export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH
$PYTHON -m build --wheel . -o /work/wheelhouse

# Debug: Examine the built wheel
cd /work/wheelhouse
mkdir -p wheel_debug
cd wheel_debug
$PYTHON -m pip install --no-index --find-links=/work/wheelhouse/ ta-lib-everywhere
$PYTHON -c "import talib; print('Successfully imported talib')" || { echo "Failed to import talib"; exit 1; }

# Repair wheel with auditwheel
cd /work
$PYTHON -m auditwheel repair wheelhouse/*.whl --plat manylinux2014_${ARCH} -w dist/