#!/bin/sh
set -e

# From https://github.com/pmq20/ruby-packer?tab=readme-ov-file#stable-releases
curl -L https://gw.alipayobjects.com/os/enclose-prod/1fd23e6b-d48f-4ed0-94dd-f0f539960253/rubyc-v0.4.0-linux-x64.gz | gzip -d > /usr/local/bin/rubyc
chmod +x /usr/local/bin/rubyc
# TODO: Use latest release isntead
git clone https://github.com/Hackplayers/evil-winrm.git "$BIN_NAME"

gem install bundler
cd "$BIN_NAME"
bundle config set --local path 'vendor/bundle'
bundle install

rubyc evil-winrm.rb -o "/out/$BIN_NAME"
