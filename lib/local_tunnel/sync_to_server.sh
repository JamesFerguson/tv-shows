#!/bin/bash
/usr/bin/ftp ftp.users.on.net << FTP_CMDS
   prompt
   lcd "~/Coding/tv-shows/lib/local_tunnel/"
   put "index.php"
   chmod 755 index.php
   quit
FTP_CMDS

