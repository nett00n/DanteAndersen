# Dante Andersen
It's a bash script for installing and base configuring dante server SOCKS5

1 `git clone git@github.com:nett00n/DanteAndersen.git`

1 Fill usersl.txt with your users

1 `bash main.sh`

* Scripts selects default IP as listening automaticaly. If anything goes wrong, you can set your IP in config.ini. Same thing with Socks5 port

* Users are set in users.txt. Configuration uses system users. If you want to delete user - use `deluser` utility

* If you use SOCKS for telegram, you can generate config links with `tgsocks.sh`

! Attention, script is tested only on Ubuntu 16.04
