sort -u /usr/src/distrib/sets/lists/base/mi /usr/src/distrib/sets/lists/comp/mi /usr/src/distrib/sets/lists/etc/mi /usr/src/distrib/sets/lists/game/mi /usr/src/distrib/sets/lists/man/mi /usr/src/xenocara/distrib/sets/lists/xbase/mi /usr/src/xenocara/distrib/sets/lists/xetc/mi /usr/src/xenocara/distrib/sets/lists/xfont/mi /usr/src/xenocara/distrib/sets/lists/xserv/mi /usr/src/xenocara/distrib/sets/lists/xshare/mi /usr/src/distrib/sets/lists/base/md.amd64 lista-site > /tmp/distopen.txt
(cd /destdir; find . | sort -u > /tmp/distpreadJ.txt)
diff /tmp/distopen.txt /tmp/distpreadJ.txt | less


