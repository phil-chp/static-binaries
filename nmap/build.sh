#!/bin/sh
set -e

git clone https://github.com/nmap/nmap.git /nmap
cd /nmap

CFLAGS="-static" LDFLAGS="-static" ./configure --with-libpcap=included --disable-shared
make -j$(nproc)
strip nmap

cp nmap "/out/${BIN_NAME}"

