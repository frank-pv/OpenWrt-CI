#!/bin/bash

# Add a feed source
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

dir_pwd=`pwd`
echo "--------------current directory is $dir_pwd --------------"

#Add
mydir='package/dev'
mkdir -p "$mydir"
cd $mydir
git clone --depth=1 --single-branch https://github.com/frank-pv/openwrt-my-config.git my-config
git clone --depth=1 --single-branch https://github.com/xiaorouji/openwrt-passwall.git
git clone --depth=1 --single-branch https://github.com/xiaorouji/openwrt-passwall-packages.git
git clone --depth=1 --single-branch https://github.com/jerrykuku/luci-theme-argon.git
git clone --depth=1 --single-branch https://github.com/jerrykuku/luci-app-argon-config.git

#argon
sed -i 's/bing/none/' luci-app-argon-config/root/etc/config/argon

#passwall
pwdir='openwrt-passwall/luci-app-passwall/root/usr/share/passwall/rules/direct_host'
pwpx='openwrt-passwall/luci-app-passwall/root/usr/share/passwall/rules/proxy_host'
sed -i '/apple.com/a\bing.com' $pwdir
sed -i '/apple.com/a\icloud.com' $pwdir
sed -i '/bing.com/d' $pwpx
mv openwrt-passwall/luci-app-passwall/ ./
rm -rf  openwrt-passwall

#chinadns
chng_dir='openwrt-passwall-packages/chinadns-ng/Makefile'
chng_sum=`curl -L 'https://github.com/zfl9/chinadns-ng/releases/download/2024.12.22/chinadns-ng+wolfssl@x86_64-linux-musl@x86_64_v2@fast+lto'| sha256sum|awk '{print $1}'`
sed -i 's/chinadns-ng+wolfssl@x86_64-linux-musl@x86_64@fast+lto/chinadns-ng+wolfssl@x86_64-linux-musl@x86_64_v2@fast+lto/' $chng_dir
sed -i "/PKG_ARCH:=chinadns-ng+wolfssl@x86_64-linux-musl@x86_64_v2@fast+lto/{n;s/\(PKG_HASH:=\).*/\1${chng_sum}/}" $chng_dir






