#!/bin/bash
/usr/bin/ftp ftp.users.on.net << FTP_CMDS
   prompt
   lcd "~/Coding/tv-shows/lib/local_tunnel/"
   put "index.html"
   put "index.php"
   put ""index.pl"
   quit
FTP_CMDS

