#!/bin/sh
#
# fapscript post target install fixup script
#

mv output/target/usr/bin/php-cgi output/target/usr/bin/php-embed
cp package/fapscript/fapscript.conf output/target/etc/
cp package/fapscript/fapscriptd.conf output/target/etc/
cp package/fapscript/fapscript output/target/fapfs/sys/bin/
cp package/fapscript/fapscriptd output/target/fapfs/sys/bin/
rm output/target/etc/php.ini
