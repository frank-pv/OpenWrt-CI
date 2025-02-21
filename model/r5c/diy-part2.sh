#!/bin/bash

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.254/g' package/base-files/files/bin/config_generate

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

dir_pwd=`pwd`
echo "--------------current directory is $dir_pwd --------------"

#smartdns
rm -rf feeds/luci/applications/luci-app-smartdns
git clone  --depth=1 --single-branch https://github.com/pymumu/luci-app-smartdns.git feeds/luci/applications/luci-app-smartdns/
sed -i 's/PKG_SOURCE_VERSION.*/PKG_SOURCE_VERSION:=07c13827bb523519a638214ed7ad76180f71a40a/' feeds/packages/net/smartdns/Makefile
sed -i 's/PKG_MIRROR_HASH.*/PKG_MIRROR_HASH:=skip/' feeds/packages/net/smartdns/Makefile
sed -i 's/^PKG_VERSION:=.*/PKG_VERSION:=46/' feeds/packages/net/smartdns/Makefile


#frp
frp_ver=`curl -s https://api.github.com/repos/fatedier/frp/releases/latest|jq -r .tag_name|sed 's/v//'`
frp_sum=`curl -L https://codeload.github.com/fatedier/frp/tar.gz/v${frp_ver}|sha256sum |awk '{print $1}'`
frp_dir='feeds/packages/net/frp/Makefile'
sed -i "s/^PKG_VERSION.*/PKG_VERSION:=$frp_ver/"  $frp_dir
sed -i "s/^PKG_HASH:=.*/PKG_HASH:=$frp_sum/"  $frp_dir
sed -i 's/conf\/$(2)_full\.ini/conf\/legacy\/\$\(2\)_legacy_full\.ini/' $frp_dir

#ddnsgo
mkdir -p 'dddd'&&cd dddd
git clone --single-branch --depth=1 https://github.com/immortalwrt/luci.git
git clone --single-branch --depth=1 https://github.com/immortalwrt/packages.git
mv luci/applications/luci-app-ddns-go/ ../feeds/luci/applications/
mv packages/net/ddns-go/ ../feeds/packages/net/
cd ../
rm -rf dddd

#update 
./scripts/feeds update -a &&./scripts/feeds install -a
