#!/bin/sh
set -e

# git clone git://repo.or.cz/socat.git /socat
# using this one for stability
git clone https://github.com/3ndG4me/socat /socat
cd /socat

CFLAGS="-static" LDFLAGS="-static" ./configure --disable-shared
make
strip socat

cp socat "/out/${BIN_NAME}"
