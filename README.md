# transmission-peer-blocker

English | [中文](README_cn.md)

## Description

Bash script for blocking bad peers in transmission with `iptables` and `ipset`.

## Requirements

- `transmission` is installed and running
- `transmission-remote` command is available
- `iptables` is available
- `ipset` package is installed
- `cronie` package is installed (Optional)

## Usage

This script can be ran manually or you can create a scheduled task with tools like `cronie`.

### 1. Download the Project

1. Either download the `transmission-peer-blocker.sh` file only or clone this repo to your Linux machine with `git clone https://github.com/askar882/transmission-peer-blocker` command.
2. Grant execute permission to the script with `chmod +x transmission-peer-blocker.sh`.

### 2. Create a Scheduled Task (Optional)

Create a scheduled task for root user with `sudo crontab -e` command and paste the following:

```crontab
*/5 * * * * /home/user/transmission-peer-blocker/transmission-peer-blocker.sh
```

> :memo: `cronie` executes `/home/user/transmission-peer-blocker/transmission-peer-blocker.sh` every 5 minutes. You can create your own scheduled task expression on [Crontab.guru](https://crontab.guru/). Don't forget to change the scripts path to the real path of it on your machine.

## References

[Transmission 屏蔽迅雷反吸血脚本](https://zhuanlan.zhihu.com/p/158711236)

[session.cpp](https://github.com/c0re100/qBittorrent-Enhanced-Edition/blob/v4_2_x/src/base/bittorrent/session.cpp#L2212)
